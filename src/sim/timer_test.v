`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 04:05:11 PM
// Design Name: 
// Module Name: timer_test
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


module timer_test();

reg clk_10Hz;
reg reset;
reg timer_on;
reg direction;
reg load;

reg [3:0] seconds_prog = 4;
reg [3:0] tens_seconds_prog = 3;
reg [3:0] minutes_prog = 2;
reg [3:0] tens_minutes_prog = 1;
// generate pulses every 1s for synchronous counters
wire pulse_1s;
defparam timer_1s.MAX_COUNT = 9;
defparam timer_1s.CTR_WIDTH = 23; // need 23b to hold 5 000 000
clock_divider timer_1s(
    .clk (clk_10Hz),
    .reset (reset),
    .pulse (pulse_1s)
);

wire [3:0] seconds_count, tens_seconds_count, minutes_count, tens_minutes_count;
time_count time_ctr(
    .clk (clk_10Hz),
    .reset (reset),
    .count_enable (pulse_1s),
    .main_enable ( timer_on ),
    .load ( load ),
    // cook time settings
    .seconds_prog ( seconds_prog ),
    .tens_seconds_prog ( tens_seconds_prog ),
    .minutes_prog ( minutes_prog ), 
    .tens_minutes_prog ( tens_minutes_prog ),
    // timer outputs
    .seconds ( seconds_count ),
    .tens_seconds ( tens_seconds_count ),
    .minutes ( minutes_count ),
    .tens_minutes ( tens_minutes_count ),
    .done ( done )
);

/// testbench stuff

initial begin
    clk_10Hz = 0;
    reset = 0;
    direction = 0;
    load = 0;
    #5;
    reset = 1;
    #5;
    reset = 0;
    timer_on = 1;

    #100000000;
    direction = 1;
    #100000000;
    load = 1;
    #200000;
    load = 0;
    #100000000;
    $finish;
end

always begin
    #50000; //10kHz
    clk_10Hz = ~clk_10Hz;
end

endmodule
