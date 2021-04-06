`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2021 09:44:09 PM
// Design Name: 
// Module Name: bargraph
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

(* use_dsp48 = "yes" *)
module bargraph(
    input wire [11:0] timer_seconds,
    input wire [11:0] prog_seconds,
    output wire [7:0] led
    );

// first we need to know how many seconds each light in the graph represents
wire [11:0] seconds_per_segment;
assign seconds_per_segment = prog_seconds >> 3; // divide by 8 using a bit shift

// bar graph thresholds
assign led[7] = ( timer_seconds >= seconds_per_segment * 7 );
assign led[6] = ( timer_seconds >= seconds_per_segment * 6 );
assign led[5] = ( timer_seconds >= seconds_per_segment * 5 );
assign led[4] = ( timer_seconds >= seconds_per_segment * 4 );
assign led[3] = ( timer_seconds >= seconds_per_segment * 3 );
assign led[2] = ( timer_seconds >= seconds_per_segment * 2 );
assign led[1] = ( timer_seconds >= seconds_per_segment );
assign led[0] = ( timer_seconds > 0 );

endmodule
