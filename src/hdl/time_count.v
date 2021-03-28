`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2021 11:41:11 PM
// Design Name: 
// Module Name: time_count
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


module time_count(
    input wire clk,
    input wire reset,
    input wire [3:0] seconds_prog,
    input wire [3:0] tens_seconds_prog,
    input wire [3:0] minutes_prog,
    input wire [3:0] tens_minutes_prog,
    output wire [3:0] seconds,
    output wire [3:0] tens_seconds,
    output wire [3:0] minutes,
    output wire [3:0] tens_minutes
    );

// main counters
wire seconds_enable, seconds_zero;
assign seconds_enable = pulse_1s & timer_on;
wire [3:0] seconds;
defparam seconds_ctr.MAX = 9;
downcounter seconds_ctr(
    .clk ( clk ),
    .enable ( seconds_enable ),
    .reset (reset),
    .start_count ( seconds_prog ),
    .count ( seconds ),
    .zero_count ( seconds_zero )
);

wire tens_seconds_enable, tens_seconds_zero;
assign tens_seconds_enable = pulse_1s & seconds_zero & timer_on;
wire [3:0] tens_seconds;
defparam tens_seconds_ctr.MAX = 5;
downcounter tens_seconds_ctr(
    .clk ( clk ),
    .enable ( tens_seconds_enable ),
    .reset (reset),
    .start_count ( tens_seconds_prog ),
    .count ( tens_seconds ),
    .zero_count ( tens_seconds_zero )
);

wire minutes_enable, minutes_zero;
assign minutes_enable = pulse_1s & seconds_zero & tens_seconds_zero & timer_on;
wire [3:0] minutes;
defparam minutes_ctr.MAX = 9;
downcounter minutes_ctr(
    .clk ( clk ),
    .enable ( minutes_enable ),
    .reset (reset),
    .start_count ( minutes_prog ),
    .count ( tens_seconds ),
    .zero_count ( tens_seconds_zero )
);

wire tens_minutes_enable, tens_minutes_zero;
assign tens_minutes_enable = pulse_1s & seconds_zero & tens_seconds_zero & minutes_zero & timer_on;
wire [3:0] tens_minutes;
downcounter tens_minutes_ctr(
    .clk ( clk ),
    .enable ( tens_minutes_enable ),
    .reset ( reset ),
    .start_count ( tens_minutes_prog ),
    .count ( tens_minutes ),
    .zero_count ( tens_seconds_zero )
);

endmodule
