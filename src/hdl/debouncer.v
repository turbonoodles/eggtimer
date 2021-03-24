`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2021 09:37:50 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input wire button,
    input wire clk,
    input wire reset,
    output wire out
    );

reg [63:0] bouncer; // updates every 5M/64 = 13us?

// basically a shift register where we want to take a poll of the outputs
always @( posedge clk, posedge reset ) begin

    if ( reset ) bouncer <= 0; // clear everyone
    else begin
        
        bouncer <= { bouncer[62:0], button };

    end
    
end

// only go high if we've got 64-in-a-row solid 1s
assign out = &bouncer;

endmodule
