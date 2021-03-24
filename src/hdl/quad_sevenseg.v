`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2021 12:31:46 PM
// Design Name: 
// Module Name: dual_sevenseg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module quad_sevenseg(
    input clk,
    input wire [3:0] digit0,
    input wire [3:0] digit1,
    input wire [3:0] digit2,
    input wire [3:0] digit3,
    output [6:0] cathodes,
    output [7:0] anodes
    );

// seven-segment decoder
reg [3:0] display_digit;
wire [3:0] bcd_in;
assign bcd_in = display_digit;

bcdto7segment display_decoder(
    .bcd_in (bcd_in),
    .seg (cathodes)
);

// anode FSM
// state definition
parameter d0 = 8'b1;
parameter d1 = 8'b10;
parameter d2 = 8'b100;
parameter d3 = 8'b1000;

// next state logic, encoded like anodes
reg [7:0] next_state;
reg [7:0] state = d0;

// next state logic
always @(state, digit0, digit1, digit2, digit3) begin
    case (state)
    // we just want to switch between digits
        d0: begin
            next_state <= d1;
            display_digit <= digit0;
        end
        d1: begin
            next_state <= d2;
            display_digit <= digit1;
        end        
        d2: begin
            next_state <= d3;
            display_digit <= digit2;
        end        
        d3: begin
            next_state <= d0;
            display_digit <= digit3;
        end
        default: begin
            next_state <= 0; // trap broken state
            display_digit <= 6'b0001110; // F to pay respects
        end
    endcase
end

// change state machine at 500Hz
always @(posedge clk) begin
    // advance the state machine
    state <= next_state;
end

// output decoding from state machine
assign anodes = ~state;

endmodule
