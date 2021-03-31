`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2021 02:14:18 PM
// Design Name: 
// Module Name: eggtimer
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


module eggtimer(
    input wire timer_on,
    input wire reset,
    input wire clk_100MHz,
    output wire [6:0] display_cathodes,
    output wire [7:0] display_anodes,
    output wire timer_enabled_led,
    output wire timer_on_led
    );

// MMCM instance to generate a 5MHz clock
clk_gen_5MHz merlin(
    // Clock out ports
    .clk_out1(clk_5MHz),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_in1)
);      // input clk_in1

// generate pulses every 1s for synchronous counters
wire pulse_1s;
defparam timer_1s.MAX_COUNT = 5000000;
defparam timer_1s.CTR_WIDTH = 23; // need 23b to hold 5 000 000
clock_divider timer_1s(
    .clk (clk_5MHz),
    .reset (reset),
    .pulse (pulse_1s)
);

// 2ms clock enable signal for 500Hz display refresh
wire pulse_2ms;
defparam timer_2ms.MAX_COUNT = 2000;
defparam timer_2ms.CTR_WIDTH = 11; // 2^11 = 2048
clock_divider timer_2ms(
    .clk (clk_5MHz),
    .reset (reset),
    .pulse (pulse_2ms)
);


wire [3:0] seconds_count, tens_seconds_count, minutes_count, tens_minutes_count;
time_count time_ctr(
    .clk (clk_5MHz),
    .reset (reset),
    // cook time settings
    .seconds_prog ( seconds_prog ),
    .tens_seconds_prog ( tens_seconds_prog ),
    .minutes_prog ( minutes_prog ), 
    .tens_minutes_prog ( tens_minutes_prog ),
    // timer outputs
    .seconds ( seconds_count ),
    .tens_seconds ( tens_seconds_count ),
    .minutes ( minutes_count ),
    .tens_minutes ( tens_minutes_count )
);

// display mux
// display_prog will be high if we are displaying the set time
assign seconds = display_prog? seconds_prog:seconds_count;
assign tens_seconds = display_prog? tens_seconds_prog:tens_seconds_count;
assign minutes = display_prog? minutes_prog:minutes_count;
assign tens_minutes = display_prog? tens_minutes_prog:tens_minutes_count;

// display instantiation
quad_sevenseg display(
    .clk (clk_5MHz),
    .clk (pulse_2ms),
    .digit0 ( seconds ),
    .digit1 ( tens_seconds ),
    .digit2 ( minutes ),
    .digit3 ( tens_minutes ),
    .cathodes ( display_cathodes ),
    .anodes ( display_anodes )
);


endmodule
