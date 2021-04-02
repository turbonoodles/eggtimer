`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 03:12:50 PM
// Design Name: 
// Module Name: cooktime_tb
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


module cooktime_tb();

reg clk_10Hz;
reg reset;
reg enable;
reg load;
reg button;

wire [3:0] ones;
wire [3:0] tens;

cooktime_count dut(
    .clk (clk_10Hz),
    .reset (reset),
    .main_enable ( enable ),
    .button_in ( button ),
    .ones( ones ),
    .tens ( tens )
);

initial begin
    clk_10Hz = 0;
    button = 0;
    reset = 0;
    #5;
    reset = 1;
    #5;
    reset = 0;
    enable = 1;

    for ( reg i = 0; i < 120; i = i + 1) begin
        #200000;
        button = 1;
        #400000;
        button = 0;
        #500000;
    end

    #10000000;

    $finish;
end

always begin
    #50000; //10Hz
    clk_10Hz = ~clk_10Hz;
end

endmodule
