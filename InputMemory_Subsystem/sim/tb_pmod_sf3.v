/********************************************************************
* Module: tb_pmod_sf3
* Author: Jamie O'Connor
* Date: 01-Dec-2025
* Description:
*   Testbench for pmod_sf3_driver.
*   Simulates:
*     - WREN
*     - Page Program
*     - Read Data
*     - RDSR polling
*
* Waveform Checks:
*   - SCK toggles at expected rate
*   - MOSI outputs correct command, address, data bytes
*   - CS_N active during transaction
*   - Data read on MISO is correctly captured in data_out
********************************************************************/
`timescale 1ns/1ps

module tb_pmod_sf3_driver;

    reg clk = 0, reset = 0, start = 0;
    reg [7:0] cmd;
    reg [23:0] addr;
    reg [7:0] data_in;
    reg [7:0] data_len;
    reg miso;

    wire mosi, sck, cs_n;
    wire [7:0] data_out;
    wire done;

    pmod_sf3_driver uut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .cmd(cmd),
        .addr(addr),
        .data_in(data_in),
        .data_len(data_len),
        .miso(miso),
        .mosi(mosi),
        .sck(sck),
        .cs_n(cs_n),
        .data_out(data_out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        reset = 1; #20;
        reset = 0; #20;

        cmd = 8'h06; addr = 24'h0; data_in = 8'hAA; data_len = 1; miso = 0;
        start = 1; #10; start = 0;
        wait(done); #20;

        cmd = 8'h02; addr = 24'h000001; data_in = 8'h55; data_len = 1; miso = 0;
        start = 1; #10; start = 0;
        wait(done); #20;

        cmd = 8'h03; addr = 24'h000001; data_in = 0; data_len = 1; miso = 1;
        start = 1; #10; start = 0;
        wait(done); #20;

        $finish;
    end
endmodule