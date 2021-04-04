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
    input wire timer_en,
    input wire reset, // no need to debounce reset
    input wire cooktime_btn,
    input wire start_btn,
    input wire minutes_btn,
    input wire seconds_btn,
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
    .clk_in1(clk_100MHz)
);      // input clk_in1

// generate pulses every 1s for synchronous counters
wire pulse_1s;
defparam timer_1s.MAX_COUNT = 4999999; // accuracy matters here
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

// pulse every 10ms - clock enable signal for debouncers
wire pulse_10ms;
defparam timer_10ms.MAX_COUNT = 10000;
defparam timer_10ms.CTR_WIDTH = 14; // 2^14 = 16 384
clock_divider timer_10ms(
    .clk (clk_5MHz),
    .reset (reset),
    .pulse (pulse_10ms)
);

wire cooktime_req; // request to enter cook time mode
debouncer cooktime_debouncer(
    .clk ( clk_5MHz ),
    .enable ( pulse_10ms ),
    .button ( cooktime_btn ),
    .reset ( reset ),
    .out ( cooktime_req )
);

wire minutes_dbnce;
debouncer minutes_debouncer(
    .clk ( clk_5MHz ),
    .enable ( pulse_10ms ),
    .button ( minutes_btn ),
    .reset ( reset ),
    .out ( minutes_dbnce )
);

wire seconds_dbnce;
debouncer seconds_debouncer(
    .clk ( clk_5MHz ),
    .enable ( pulse_10ms ),
    .button ( seconds_btn ),
    .reset ( reset ),
    .out ( seconds_dbnce )
);

wire [3:0] seconds_count, tens_seconds_count, minutes_count, tens_minutes_count;
time_count main_timer(
    .clk (clk_5MHz),
    .reset (reset),
    .count_enable ( pulse_1s ),
    .main_enable ( timer_on ),
    .load ( load_main_timer ),
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

// individual counters for minutes and seconds to allow setting individually
cooktime_count seconds_set(
    .clk ( clk_5MHz ),
    .button_in ( increment_seconds ),
    .pulse_in ( pulse_300ms ),
    .main_enable ( prog_mode ),
    .reset ( reset ),
    // set time outputs
    .ones ( seconds_prog ),
    .tens ( tens_seconds_prog )
);

cooktime_count minutes_set(
    .clk ( clk_5MHz ),
    .button_in ( increment_minutes ),
    .pulse_in ( pulse_300ms ),
    .main_enable ( prog_mode ),
    .reset ( reset ),
    // set time outputs
    .ones ( minutes_prog ),
    .tens ( tens_minutes_prog )
);

// main controller
// - allow setting time when in time setting mode and holding button 
// - load time from set counters when transistioning to countdown timer mode
main_control controller(
    .clk ( clk_5MHz),
    .reset ( reset ),
    .cooktime_req ( cooktime_req ), // debounced button
    .start_timer ( start_btn ),
    .seconds_req ( seconds_dbnce ),
    .minutes_req ( minutes_dbnce ),
    .timer_en ( timer_en ), // switch input
    .timer_done ( timer_done ),

    .increment_seconds ( increment_seconds ),
    .increment_minutes ( increment_minutes ),
    .prog_mode ( prog_mode ),
    .timer_enabled_led ( timer_enabled_led ),
    .timer_on_led ( timer_on_led ),
    .main_timer_enable ( timer_on ),
    .load_timer ( load_main_timer )
);

// display mux
// prog_mode will be high if we are displaying the set time
assign seconds = prog_mode? seconds_prog:seconds_count;
assign tens_seconds = prog_mode? tens_seconds_prog:tens_seconds_count;
assign minutes = prog_mode? minutes_prog:minutes_count;
assign tens_minutes = prog_mode? tens_minutes_prog:tens_minutes_count;

// display instantiation
quad_sevenseg display(
    .clk (clk_5MHz),
    .clk_enable (pulse_2ms),
    .digit0 ( seconds ),
    .digit1 ( tens_seconds ),
    .digit2 ( minutes ),
    .digit3 ( tens_minutes ),
    .cathodes ( display_cathodes ),
    .anodes ( display_anodes )
);

endmodule
