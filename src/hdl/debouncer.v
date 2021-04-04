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
    input wire enable,
    input wire reset,
    output reg out
    );

// this parameter will decide how long our button needs to be constant
// in order to generate an output
// BOUNCE_DELAY = 2 is a standard debouncer; raise BOUNCE_DELAY to 
// force the button to be held for a period of time
parameter BOUNCE_DELAY = 2; 

reg [BOUNCE_DELAY - 1:0] bouncer;

// basically a shift register where we want to take a poll of the outputs
always @( posedge clk, posedge reset ) begin

    if ( reset ) bouncer <= 0; // clear everyone
    else begin
        
        if ( enable ) begin
           bouncer <= { bouncer[BOUNCE_DELAY-2:0], button };
           out <= &bouncer;
        end
    end
    
end

endmodule
