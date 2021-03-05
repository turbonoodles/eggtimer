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


module dual_sevenseg(
    input clk,
    input wire [3:0] tens,
    input wire [3:0] ones,
    output [6:0] cathodes,
    output [7:0] anodes
    );

// seven-segment decoder
reg [3:0] display_digit;
wire [3:0] bcd_in;
assign bcd_in = display_digit;
bcdto7segment disp0(
    .bcd_in (bcd_in),
    .seg (cathodes)
);

// anode FSM
// state definition
parameter lsd = 8'b1;
parameter msd = 8'b10;

// next state logic, encoded like anodes
reg [7:0] next_state;
reg [7:0] state = lsd;

// next state logic
always @(state, ones, tens) begin
    case (state)
    // we just want to switch between digits
        lsd: begin
            next_state <= msd;
            display_digit <= ones;
        end
        msd: begin
            next_state <= lsd;
            display_digit <= tens; // actual mux
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
