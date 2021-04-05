`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2021 10:47:18 AM
// Design Name: 
// Module Name: display_tb
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


module display_tb();

reg clk_1kHz;
reg reset;
reg [3:0] seconds, tens_seconds, minutes, tens_minutes;
wire [7:0] display_anodes;
wire [6:0] display_cathodes;

// pulse every 10ms - clock enable signal for debouncers
wire pulse_25ms;
defparam timer_25ms.MAX_COUNT = 4;
defparam timer_25ms.CTR_WIDTH = 4; // 2^14 = 16 384
clock_divider timer_25ms(
    .clk (clk_1kHz),
    .reset (reset),
    .pulse (pulse_25ms)
);


// display instantiation
quad_sevenseg display(
    .clk (clk_1kHz),
    .clk_enable (pulse_25ms),
    .digit0 ( seconds ),
    .digit1 ( tens_seconds ),
    .digit2 ( minutes ),
    .digit3 ( tens_minutes ),
    .cathodes ( display_cathodes ),
    .anodes ( display_anodes )
);

always begin
    #500;
    clk_1kHz = ~clk_1kHz;
end

initial begin
    reset = 0;
    clk_1kHz = 0;
    #10;
    reset = 1;
    #10; 
    reset = 0;

    seconds = 4;
    tens_seconds = 3;
    minutes = 2;
    tens_minutes = 1;

    #50000;

    seconds = 5;
    tens_seconds = 6;
    minutes = 7;
    tens_minutes = 8;

    #50000;
    
    seconds = 9;
    tens_seconds = 8;
    minutes = 7;
    tens_minutes = 6;

    #50000;
    $finish;
    
end
endmodule
