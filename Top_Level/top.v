`timescale 1ns / 1ps

module top(
    input  wire        clk,          // 100 MHz system clock
    input  wire        rst,          // reset button (active high)

    // VGA outputs
    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b,

    // Keypad (Pmod KYPD)
    input  wire [3:0]  kypd_rows,    // rows are inputs
    output wire [3:0]  kypd_cols,    // columns are outputs

    // Joystick (Pmod JSTK2 - SPI)
    output wire        jstk_sck,
    output wire        jstk_mosi,
    input  wire        jstk_miso,
    output wire        jstk_cs,

    // Flash memory (Pmod SF3 - SPI)
    output wire        flash_sck,
    output wire        flash_mosi,
    input  wire        flash_miso,
    output wire        flash_cs
);

    // Internal wires
    wire [3:0] key_code;
    wire [11:0] rgb;          // Test pattern RGB

    // System controller output
    wire [7:0] sys_state;

    // ------------------------------------------------------------
    // KEYBOARD DECODER (Member B)
    // ------------------------------------------------------------
    decoder keypad_unit(
        .clk_100MHz(clk),
        .row(kypd_rows),
        .col(kypd_cols),
        .key_code(key_code)
    );

    // ------------------------------------------------------------
    // VGA TEST PATTERN (Member A)
    // ------------------------------------------------------------
    vga_test vga_test_unit(
        .clk(clk),
        .reset(rst),
        .sw(12'hFFF),    // White test pattern until real graphics
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    // Map 12-bit RGB into 4:4:4 VGA outputs
    assign vga_r = rgb[11:8];
    assign vga_g = rgb[7:4];
    assign vga_b = rgb[3:0];

    // ------------------------------------------------------------
    // SYSTEM CONTROLLER (Member C)
    // ------------------------------------------------------------
    system_controller sys_ctrl(
        .clk(clk),
        .rst(rst),
        .key_code(key_code),
        .state(sys_state)
    );

    // ------------------------------------------------------------
    // Joystick + Flash left unconnected (Week 4-5 work)
    // ------------------------------------------------------------
    assign jstk_sck  = 1'b0;
    assign jstk_mosi = 1'b0;
    assign jstk_cs   = 1'b1;

    assign flash_sck  = 1'b0;
    assign flash_mosi = 1'b0;
    assign flash_cs   = 1'b1;

endmodule
