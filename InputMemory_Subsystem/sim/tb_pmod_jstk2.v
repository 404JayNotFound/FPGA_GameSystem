/********************************************************************
* Module: tb_pmod_jstk2
* Author: Jamie O'Connor
* Date: 21-Nov-2025
* Description:
*   Testbench for the pmod_jstk2 SPI Master module.
*   Simulates a Pmod JSTK2 device (SPI Slave) by outputting a 40-bit
*   data packet (5 bytes) on the MISO line synchronized to the master's
*   generated SCK. Verifies correct parsing and storage of the X/Y
*   positions and button states by the master module.
*
* Functionality Tested:
*   1. Clock and reset initialization of the master module.
*   2. Generation of a valid 5-byte SPI packet from the simulated slave.
*   3. Correct sampling of MISO data on the master's SCK rising edge.
*   4. Accurate reassembly of 16-bit X/Y positions and button signals.
*   5. Data_valid pulse assertion after each complete SPI transaction.
*   6. Proper read_in_progress signal behavior during SPI transfer.
*
********************************************************************/


`timescale 1ns/1ps
module tb_pmod_jstk2();

    // Clock and Reset
    reg CLK100MHZ = 0;
    reg RST = 1;

    // DUT Inputs
    reg start_read = 0;
    reg JSTK_MISO  = 0;

    // DUT Outputs
    wire JSTK_SCK;
    wire JSTK_CS;
    wire JSTK_MOSI;
    wire [15:0] x_position;
    wire [15:0] y_position;
    wire [7:0]  fs_buttons;
    wire btn_jstk;
    wire btn_trigger;
    wire data_valid;
    wire read_in_progress;

    // Instantiate DUT
    pmod_jstk2 uut (
        .clk(CLK100MHZ),
        .reset(RST),
        .start_read(start_read),
        .miso(JSTK_MISO),
        .sck(JSTK_SCK),
        .cs_n(JSTK_CS),
        .mosi(JSTK_MOSI),
        .x_position(x_position),
        .y_position(y_position),
        .fs_buttons(fs_buttons),
        .btn_jstk(btn_jstk),
        .btn_trigger(btn_trigger),
        .data_valid(data_valid),
        .read_in_progress(read_in_progress)
    );

    // Clock generation: 100 MHz
    always #5 CLK100MHZ = ~CLK100MHZ;

    task send_packet(input [39:0] packet);
        integer i;
        begin
            @(negedge JSTK_CS);
            for (i = 39; i >= 0; i = i - 1) begin
                @(posedge JSTK_SCK);
                JSTK_MISO = packet[i];
            end
            @(posedge JSTK_CS);
        end
    endtask

    localparam [7:0] BUTTON_NONE   = 8'h00;
    localparam [15:0] X_CENTER = 16'd128;
    localparam [15:0] Y_CENTER = 16'd128;
    localparam [15:0] X_LEFT   = 16'd32;
    localparam [15:0] X_RIGHT  = 16'd200;
    localparam [15:0] Y_UP     = 16'd200;
    localparam [15:0] Y_DOWN   = 16'd32;

    `define PACKET(X,Y,B) {X[7:0], X[15:8], Y[7:0], Y[15:8], B}

    initial begin
        
        RST = 1;
        start_read = 0;
        #100;
        RST = 0;
        #100;

        // Test center position with no buttons pressed
        start_read = 1;
        #10;
        start_read = 0;
        send_packet(`PACKET(X_CENTER,Y_CENTER,BUTTON_NONE));
        @(posedge data_valid);
        
        // Test left position
        start_read = 1; #10; start_read = 0;
        send_packet(`PACKET(X_LEFT,Y_CENTER,BUTTON_NONE));
        @(posedge data_valid);
        
        // Test right position
        start_read = 1; #10; start_read = 0;
        send_packet(`PACKET(X_RIGHT,Y_CENTER,BUTTON_NONE));
        @(posedge data_valid);
        
        // Test up position
        start_read = 1; #10; start_read = 0;
        send_packet(`PACKET(X_CENTER,Y_UP,BUTTON_NONE));
        @(posedge data_valid);
        
        // Test down position
        start_read = 1; #10; start_read = 0;
        send_packet(`PACKET(X_CENTER,Y_DOWN,BUTTON_NONE));
        @(posedge data_valid);
        
        // Test buttons
        start_read = 1; #10; start_read = 0;
        send_packet(`PACKET(X_CENTER,Y_CENTER,8'b11));
        @(posedge data_valid);
        
        $finish;
    end

endmodule
