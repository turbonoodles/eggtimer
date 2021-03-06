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
    input wire count_enable,
    input wire main_enable,
    input wire reset,
    input wire load,
    // cook time input
    input wire [3:0] seconds_prog,
    input wire [3:0] tens_seconds_prog,
    input wire [3:0] minutes_prog,
    input wire [3:0] tens_minutes_prog,
    // current timer output
    output wire [3:0] seconds,
    output wire [3:0] tens_seconds,
    output wire [3:0] minutes,
    output wire [3:0] tens_minutes,
    output wire done
    );

parameter TIMER_DIRECTION = 1'b0;

// main counters
wire seconds_enable, seconds_zero;
assign seconds_enable = count_enable & main_enable;
defparam seconds_ctr.MAX = 9;
defparam seconds_ctr.DIRECTION = TIMER_DIRECTION; // countdown
digit_counter seconds_ctr(
    .clk ( clk ),
    .enable ( seconds_enable ),
    .load ( load ),
    .reset (reset),
    .start_count ( seconds_prog ),
    .count ( seconds ),
    .term_count ( seconds_zero )
);

wire tens_seconds_enable, tens_seconds_zero;
assign tens_seconds_enable = count_enable & seconds_zero & main_enable;
defparam tens_seconds_ctr.MAX = 5;
defparam tens_seconds_ctr.DIRECTION = TIMER_DIRECTION;
digit_counter tens_seconds_ctr(
    .clk ( clk ),
    .enable ( tens_seconds_enable ),
    .load ( load ),
    .reset (reset),
    .start_count ( tens_seconds_prog ),
    .count ( tens_seconds ),
    .term_count ( tens_seconds_zero )
);

wire minutes_enable, minutes_zero;
assign minutes_enable = count_enable & seconds_zero & tens_seconds_zero & main_enable;
defparam minutes_ctr.MAX = 9;
defparam minutes_ctr.DIRECTION = TIMER_DIRECTION;
digit_counter minutes_ctr(
    .clk ( clk ),
    .enable ( minutes_enable ),
    .load ( load ),
    .reset (reset),
    .start_count ( minutes_prog ),
    .count ( minutes ),
    .term_count ( minutes_zero )
);

wire tens_minutes_enable, tens_minutes_zero;
assign tens_minutes_enable = count_enable & seconds_zero & tens_seconds_zero & minutes_zero & main_enable;
defparam tens_minutes_ctr.DIRECTION = TIMER_DIRECTION;
digit_counter tens_minutes_ctr(
    .clk ( clk ),
    .enable ( tens_minutes_enable ),
    .load ( load ),
    .reset ( reset ),
    .start_count ( tens_minutes_prog ),
    .count ( tens_minutes ),
    .term_count ( tens_minutes_zero )
);

assign done = seconds_zero & tens_seconds_zero & minutes_zero & tens_minutes_zero; 

endmodule
