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
    );

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




endmodule
