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
wire [2:0] rem; // "remainder" after integer division by bitshift
assign rem = seconds_per_segment[2:0]; // every place less than 8 will be a remainder
assign seconds_per_segment = prog_seconds >> 3; // divide by 8 using a bit shift

// bar graph thresholds
// handle remainders by spreading 'evenly' among segments
// seven - all segments beside zero
// six - all segments beside zero and seven
// five - 7, 6, 4, 3, 1
// four - odd segments only 
// three - 7, 5, 3
// two - 7, 4
// one - 7 only
assign led[7] = timer_seconds >= ( seconds_per_segment * 7 + 
    ( rem == 7 )|( rem == 5 )|( rem == 4 )|( rem==3 )|( rem == 2 )|( rem == 1) ); 
assign led[6] = timer_seconds >= ( seconds_per_segment * 6  + 
    ( rem == 7 )| (rem == 6 )|( rem == 5 ) );
assign led[5] = timer_seconds >= ( seconds_per_segment * 5 +
    ( rem == 7 )|( rem == 6 )|( rem == 4 )|( rem == 3) );
assign led[4] = timer_seconds >= ( seconds_per_segment * 4 + 
    ( rem == 7 )|( rem == 6 )|( rem == 5 )|( rem == 2 ) );
assign led[3] = timer_seconds >= ( seconds_per_segment * 3 + 
    ( rem == 7 )|( rem == 6 )|( rem == 5 )|( rem == 4 )|( rem == 3) );
assign led[2] = timer_seconds >= ( seconds_per_segment * 2 +
    ( rem == 7)|( rem == 6 ) );
assign led[1] = timer_seconds >= ( seconds_per_segment +
    ( rem == 7 )|( rem == 6 )|( rem == 5 )|(rem == 4) );
assign led[0] = ( timer_seconds > 0 );

endmodule
