`timescale 1us / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 04:51:19 PM
// Design Name: 
// Module Name: downcounter_tb
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


module downcounter_tb();

reg clk_10Hz;
reg [3:0] seconds_prog = 2;
reg reset;
reg load;

wire[3:0] seconds;

wire pulse_1s;
defparam timer_1s.MAX_COUNT = 9; // n - 1 for accurate timing
defparam timer_1s.CTR_WIDTH = 23; // need 23b to hold 5 000 000
clock_divider timer_1s(
    .clk (clk_10Hz),
    .reset (reset),
    .pulse (pulse_1s)
);

defparam seconds_ctr.WIDTH = 4;
defparam seconds_ctr.MAX = 9;
defparam seconds_ctr.DIRECTION = 1'b0;
digit_counter seconds_ctr(
    .clk ( clk_10Hz ),
    .enable ( pulse_1s ),
    .reset (reset),
    .load (load),
    .start_count ( seconds_prog ),
    .count ( seconds ),
    .term_count ( seconds_zero )
);

initial begin
    clk_10Hz = 0;
    reset = 0;
    load = 0;
    #5;
    reset = 1;
    #5;
    reset = 0;

    #5000000;
    reset = 1;
    #10;
    reset = 0;
    #5000000;
    load = 1;
    #200000;
    load = 0;
    #5000000;
    $finish;
end

always begin
    #50000; //10Hz
    clk_10Hz = ~clk_10Hz;
end

endmodule
