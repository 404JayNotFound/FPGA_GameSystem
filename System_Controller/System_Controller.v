`timescale 1ns / 1ps

module system_controller(
    input  wire       clk,
    input  wire       rst,          // active high reset
    input  wire [3:0] key_code,     // keypad from decoder
    output reg  [7:0] state
);

    // Simple state encoding
    localparam S_RESET        = 0;
    localparam S_IDLE         = 1;
    localparam S_WAIT_KEY     = 2;
    localparam S_GAME_ACTIVE  = 3;

    reg [7:0] next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            S_RESET: begin
                next_state = S_IDLE;
            end

            S_IDLE: begin
                next_state = S_WAIT_KEY;
            end

            S_WAIT_KEY: begin
                if (key_code != 4'b0000)
                    next_state = S_GAME_ACTIVE;
                else
                    next_state = S_WAIT_KEY;
            end

            S_GAME_ACTIVE: begin
                // In Week 3 nothing returns us out of GAME_ACTIVE yet
                next_state = S_GAME_ACTIVE;
            end

            default: next_state = S_RESET;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (rst)
            state <= S_RESET;
        else
            state <= next_state;
    end

endmodule
