`timescale 1ns / 1ps

module top(
    input  wire        clk,          // 100 MHz system clock
    input  wire        rst,          // reset (active high)

    // VGA outputs
    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b,

    // Pmod KYPD
    input  wire [3:0]  kypd_rows,
    output wire [3:0]  kypd_cols,

    // Pmod JSTK2
    input  wire        jstk_miso,
    output wire        jstk_mosi,
    output wire        jstk_sck,
    output wire        jstk_cs,   // active-low

    // Pmod SF3 Flash
    input  wire        flash_miso,
    output wire        flash_mosi,
    output wire        flash_sck,
    output wire        flash_cs    // active-low
);

    // ============================================================
    // CLOCK DIVIDER: Create 25 MHz pixel clock for VGA
    // ============================================================
    reg [1:0] clk_div = 0;
    always @(posedge clk)
        clk_div <= clk_div + 1;

    wire clk_25 = clk_div[1];

    // ============================================================
    // KEYPAD DECODER
    // ============================================================
    wire [3:0] key_code;

    decoder keypad_inst (
        .clk_100MHz(clk),
        .row(kypd_rows),
        .col(kypd_cols),
        .key_code(key_code)
    );

    // ============================================================
    // SYSTEM CONTROLLER
    // ============================================================
    wire [7:0] game_state;

    system_controller sys_ctrl_inst (
        .clk(clk),
        .rst(rst),
        .key_code(key_code),
        .state(game_state)
    );

    // ============================================================
    // VGA SYNC GENERATOR
    // ============================================================
    wire video_on;
    wire p_tick;
    wire [9:0] x;
    wire [9:0] y;

    vga_sync vga_sync_inst (
        .clk(clk_25),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_tick(p_tick),
        .x(x),
        .y(y)
    );

    // ============================================================
    // SIMPLE TEST PATTERN (replace later)
    // ============================================================
    assign vga_r = (video_on ? {4{x[5]}} : 4'b0);
    assign vga_g = (video_on ? {4{y[5]}} : 4'b0);
    assign vga_b = (video_on ? {4{game_state[0]}} : 4'b0);

    // ============================================================
    // PMOD JSTK2 INSTANTIATION
    // ============================================================
    wire [15:0] jstk_x;
    wire [15:0] jstk_y;
    wire [7:0]  jstk_buttons;

    pmod_jstk2 jstk_inst (
        .clk(clk),
        .reset(rst),

        .miso(jstk_miso),
        .mosi(jstk_mosi),
        .sck(jstk_sck),
        .cs_n(jstk_cs),     // active-low

        .x_pos(jstk_x),
        .y_pos(jstk_y),
        .buttons(jstk_buttons)
    );

    // ============================================================
    // PMOD SF3 FLASH INSTANTIATION
    // ============================================================
    wire flash_done;

    pmod_sf3 flash_inst (
        .clk(clk),
        .reset(rst),

        .start(1'b0),       // not used yet
        .cmd(8'h00),
        .addr(24'h000000),
        .data_in(8'h00),

        .miso(flash_miso),
        .mosi(flash_mosi),
        .sck(flash_sck),
        .cs_n(flash_cs),    // active-low

        .data_out(),        // ignored for now
        .busy(),
        .done(flash_done)
    );

endmodule
