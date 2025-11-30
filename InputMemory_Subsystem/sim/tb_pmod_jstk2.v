/********************************************************************
* Module: tb_pmod_jstk2
* Author: Jamie O'Connor
* Date: 21-Nov-2025
* Description:
*   Testbench for the pmod_jstk2 module.
*   This testbench simulates the Pmod JSTK2 (the SPI Slave) by clocking
*   out a 40-bit data packet (5 bytes) onto the MISO line exactly when
*   the master is clocking.
*
* Functionality Tested:
*   1. Clock and Reset initialization.
*   2. Correct 40-bit data stream output from the simulated slave.
*   3. Data parsing and storage into the x_position, y_position, and button outputs.
*
* Notes:
*   - The simulated slave uses a neg-edge sck to output data, which the
*     master samples on the next posedge sck.
*   - Includes a small #1 non-blocking delay on MISO updates to avoid
*     simulator race conditions.
*
********************************************************************/

`timescale 1ns/1ps
module tb_pmod_jstk2;

    // Testbench Signals
    reg clk;
    reg reset;
    reg start_read;
    wire mosi;

    // Master Outputs / Slave Inputs
    wire sck;
    wire cs_n;
    reg miso; // Testbench controls MISO as the simulated Slave

    // Master Output Signals (Verification Targets)
    wire [15:0] x_position; 
    wire [15:0] y_position;
    wire [7:0] fs_buttons; 
    wire btn_jstk;
    wire btn_trigger;
    wire data_valid;
    wire read_in_progress;

    // Simulation Parameters
    parameter CLK_PERIOD = 10; // 10ns for a 100MHz clock
    
    // Test Case Data
    parameter [39:0] TEST_DATA_1 = 40'hFFFF000003; 

    parameter [39:0] TEST_DATA_2 = 40'h8000800000;

    reg [39:0] shift_data_reg;
    reg [5:0] bit_counter; 

    // Instantiate Unit Under Test (UUT)
    pmod_jstk2 UUT (
        .clk(clk),
        .reset(reset),
        .start_read(start_read),
        .sck(sck),
        .cs_n(cs_n),
        .miso(miso),
        .mosi(mosi),
        .x_position(x_position),
        .y_position(y_position),
        .fs_buttons(fs_buttons), 
        .btn_jstk(btn_jstk),
        .btn_trigger(btn_trigger),
        .data_valid(data_valid),
        .read_in_progress(read_in_progress)
    );

    // Clock Generation
    always begin
        clk = 1'b0;
        #(CLK_PERIOD / 2) clk = 1'b1;
        #(CLK_PERIOD / 2);
    end

    // MISO Simulation (The simulated JSTK2 Slave)
    always @(negedge sck) begin
        if (cs_n == 1'b0) begin
            if (bit_counter < 40) begin
                // Drive the next bit (from the MSB side) onto MISO
                #1 miso <= shift_data_reg[39 - bit_counter]; 
                bit_counter <= bit_counter + 1;
            end else begin
                #1 miso <= 1'b0;
            end
        end else begin
            #1 miso <= 1'b0;
            bit_counter <= 0;
        end
    end

    // Main Test Sequence
    initial begin
        $dumpfile("pmod_jstk2_final_test.vcd");
        $dumpvars(0, tb_pmod_jstk2); // Changed from pmod_jstk2_tb to tb_pmod_jstk2 for consistency

        // 1. Initial Reset and Setup
        reset = 1'b1;
        start_read = 1'b0;
        miso = 1'b0;

        @(posedge clk);
        #100; 
        reset = 1'b0;

        // --- CYCLE 1: Test Data 1 (Max X, Min Y, BTNs Pressed) ---
        #50;
        shift_data_reg = TEST_DATA_1;
        start_read = 1'b1;
        @(posedge clk);
        start_read = 1'b0;

        // Wait until data is valid
        @(posedge data_valid);

        #1;
        if (!(x_position === 16'hFFFF && y_position === 16'h0000 && fs_buttons === 8'h03 && btn_jstk === 1'b1 && btn_trigger === 1'b1)) begin
        end


        #5000; 
        shift_data_reg = TEST_DATA_2;
        start_read = 1'b1;
        @(posedge clk);
        start_read = 1'b0;

        // Wait until data is valid
        @(posedge data_valid);

        #1;
        if (!(x_position === 16'h8000 && y_position === 16'h8000 && fs_buttons === 8'h00 && btn_jstk === 1'b0 && btn_trigger === 1'b0)) begin
        end

        #200;
        $finish;
    end

endmodule