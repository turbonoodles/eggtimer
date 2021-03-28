`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2021 09:22:02 PM
// Design Name: 
// Module Name: clock_divider_tb
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


module clock_divider_tb();

reg clk;
reg reset;
wire pulse_1s;

defparam dut.CTR_WIDTH = 22;
defparam dut.MAX_COUNT = 22'd500000;

clock_divider dut (
    .clk (clk),
    .reset (reset),
    .pulse (pulse_1s)
);

always begin
    #1;
    clk <= ~clk;
end

initial begin
    reset = 0;
    clk = 0;
    #10;
    reset = 1;
    #10;
    reset = 0;

    #10000000;
    $finish;
end

endmodule
