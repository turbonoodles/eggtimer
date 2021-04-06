`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2021 07:48:59 PM
// Design Name: 
// Module Name: seconds_converter
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

// want the multipliers in the DSP48E1 slice
(* use_dsp48 = "yes" *)

module seconds_converter(
    input wire clk,
    input wire load,
    input wire reset,
    input wire [3:0] tens_minutes,
    input wire [3:0] minutes,
    input wire [3:0] tens_seconds,
    input wire [3:0] seconds,
    // timer can run for 1h = 3600s; fits in 12b ( max 4096 )
    output reg [11:0] seconds_out
    );

// individually converted to seconds
reg [11:0] tens_minutes_seconds, minutes_seconds, tens_seconds_seconds, seconds_seconds;

always @( posedge clk, posedge reset ) begin
    
    if ( reset ) begin
        tens_minutes_seconds <= 0;
        minutes_seconds <= 0;
        tens_seconds_seconds <= 0;
        seconds_seconds <= 0;
    end

    else begin
        if ( load ) begin
            tens_minutes_seconds <= tens_minutes * 600;
            minutes_seconds <= minutes * 60;
            tens_seconds_seconds <= tens_seconds * 10;
            seconds_seconds <= seconds;
        end
    end
end

always @( * ) begin
    seconds_out = tens_minutes_seconds + minutes_seconds + tens_seconds_seconds + seconds_seconds;
end

endmodule
   
