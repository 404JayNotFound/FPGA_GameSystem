/********************************************************************
* Module: pmod_sf3
* Author: Jamie O'Connor
* Date: 01-Dec-2025
* Description:
*   Synthesizable SPI Master for Pmod SF3 flash (N25Q256A).
*   Handles command, address, data transfers and automatic polling
*   for write-complete operations.
*
* Inputs:
*   clk        - System clock
*   reset      - Asynchronous reset
*   start      - Initiates a transaction
*   cmd[7:0]   - SPI command byte
*   addr[23:0] - 24-bit address
*   data_in[7:0] - Data for write operations
*   data_len[7:0] - Number of bytes to transfer
*   miso       - SPI MISO input
*
* Outputs:
*   mosi       - SPI MOSI output
*   sck        - SPI clock
*   cs_n       - Chip select (active low)
*   data_out[7:0] - Data captured during reads
*   done       - Transaction completion pulse
*
********************************************************************/
`timescale 1ns/1ps
module pmod_sf3(
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [7:0]  cmd,
    input  wire [23:0] addr,
    input  wire [7:0]  data_in,
    input  wire [7:0]  data_len,
    input  wire        miso,
    output reg         mosi,
    output reg         sck,
    output reg         cs_n,
    output reg [7:0]   data_out,
    output reg         done
);

    localparam [7:0]
        CMD_READ  = 8'h03,
        CMD_WREN  = 8'h06,
        CMD_PP    = 8'h02,
        CMD_RDSR  = 8'h05;

    parameter SCK_DIVIDER = 20;
    parameter CS_DELAY    = 50;
    parameter POST_DELAY  = 50;

    localparam [3:0]
        IDLE       = 0,
        CS_LOW     = 1,
        XFER_CMD   = 2,
        XFER_ADDR  = 3,
        XFER_DATA  = 4,
        CS_HIGH    = 5,
        POLL_INIT  = 6,
        POLL_XFER  = 7,
        DONE_PULSE = 8;

    reg [3:0] state, next_state;
    reg [4:0] sck_count;
    reg [2:0] bit_idx;
    reg [7:0] shift_reg;
    reg [7:0] byte_cnt;
    reg [7:0] data_cnt;
    reg [7:0] delay_count;
    reg sck_rising, sck_falling;
    reg [7:0] status_reg;
    reg [7:0] current_cmd;

    wire [7:0] data_to_load;
    wire byte_complete = (bit_idx == 0 && sck_falling);

    wire is_transfer_state = (state == XFER_CMD || state == XFER_ADDR || state == XFER_DATA || state == POLL_XFER);
    wire is_next_transfer_state = (next_state == XFER_CMD || next_state == XFER_ADDR || next_state == XFER_DATA || next_state == POLL_XFER);
    wire needs_addr = (current_cmd == CMD_READ || current_cmd == CMD_PP);
    wire needs_data = (current_cmd == CMD_READ || current_cmd == CMD_PP || current_cmd == CMD_RDSR);
    wire needs_poll = (current_cmd == CMD_PP);

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sck <= 0;
            sck_count <= 0;
            sck_rising <= 0;
            sck_falling <= 0;
        end else if(is_transfer_state) begin
            if(sck_count == SCK_DIVIDER-1) begin
                sck_count <= 0;
                sck <= ~sck;
                sck_rising <= ~sck;
                sck_falling <= sck;
            end else begin
                sck_count <= sck_count + 1;
                sck_rising <= 0;
                sck_falling <= 0;
            end
        end else begin
            sck <= 0;
            sck_count <= 0;
            sck_rising <= 0;
            sck_falling <= 0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            cs_n <= 1;
            mosi <= 0;
            bit_idx <= 7;
            shift_reg <= 0;
            byte_cnt <= 0;
            data_cnt <= 0;
            data_out <= 0;
            done <= 0;
            delay_count <= 0;
            status_reg <= 0;
            current_cmd <= 0;
        end else begin
            state <= next_state;
            done <= 0;

            case(state)
                IDLE:       if (start) current_cmd <= cmd;
                CS_LOW:     delay_count <= delay_count + 1;
                CS_HIGH:    delay_count <= delay_count + 1;
                DONE_PULSE: done <= 1;
            endcase

            if(is_transfer_state) begin
                if(sck_rising) mosi <= shift_reg[7];
                if(sck_falling) begin
                    shift_reg <= {shift_reg[6:0], miso};
                    if(bit_idx == 0) bit_idx <= 7;
                    else bit_idx <= bit_idx - 1;
                    if (state == XFER_DATA) data_out <= {data_out[6:0], miso};
                    if (state == POLL_XFER) status_reg <= {status_reg[6:0], miso};
                end
            end

            if (is_next_transfer_state) begin
                if (state == CS_LOW && next_state == XFER_CMD) begin
                    shift_reg <= data_to_load;
                    byte_cnt <= 0;
                    data_cnt <= 0;
                end else if (state == POLL_INIT || state == CS_HIGH) begin
                    shift_reg <= data_to_load;
                end else if (byte_complete) begin
                    shift_reg <= data_to_load;
                    if (state == XFER_ADDR) byte_cnt <= byte_cnt + 1;
                    if (state == XFER_DATA) data_cnt <= data_cnt + 1;
                end
            end
        end
    end

    always @(*) begin
        next_state = state;
        data_to_load = 8'h00;

        case(state)
            IDLE: if(start) next_state = CS_LOW;
            CS_LOW: if(delay_count >= CS_DELAY) next_state = XFER_CMD;

            XFER_CMD:
                if(byte_complete) begin
                    if(needs_addr) next_state = XFER_ADDR;
                    else if(needs_data) next_state = XFER_DATA;
                    else next_state = CS_HIGH;
                end

            XFER_ADDR:
                if(byte_complete && byte_cnt == 2) next_state = XFER_DATA;

            XFER_DATA:
                if(byte_complete && data_cnt == data_len - 1) next_state = CS_HIGH;

            CS_HIGH:
                if(delay_count >= POST_DELAY) begin
                    if(needs_poll && current_cmd == CMD_PP) next_state = POLL_INIT;
                    else next_state = DONE_PULSE;
                end

            POLL_INIT: next_state = POLL_XFER;

            POLL_XFER:
                if(byte_complete) begin
                    if(status_reg[0] == 1'b1) next_state = CS_HIGH;
                    else next_state = DONE_PULSE;
                end

            DONE_PULSE: next_state = IDLE;
        endcase

        case(next_state)
            XFER_CMD:  data_to_load = current_cmd;
            XFER_ADDR: begin
                if (state == XFER_CMD) data_to_load = addr[23:16];
                else if (state == XFER_ADDR && byte_cnt == 1) data_to_load = addr[15:8];
                else if (state == XFER_ADDR && byte_cnt == 2) data_to_load = addr[7:0];
            end
            XFER_DATA: data_to_load = (current_cmd == CMD_READ || current_cmd == CMD_RDSR) ? 8'h00 : data_in;
            POLL_XFER: data_to_load = CMD_RDSR;
        endcase
    end
endmodule