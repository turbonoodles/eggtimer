`timescale 1us / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2021 07:16:43 PM
// Design Name: 
// Module Name: debouncer_tb
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


module debouncer_tb();

reg reset;
reg button;
reg clk_1kHz;
reg [31:0] i;

// pulse every 10ms - clock enable signal for debouncers
wire pulse_10ms;
defparam timer_10ms.MAX_COUNT = 10;
defparam timer_10ms.CTR_WIDTH = 4; // 2^14 = 16 384
clock_divider timer_10ms(
    .clk (clk_1kHz),
    .reset (reset),
    .pulse (pulse_10ms)
);

debouncer seconds_debouncer(
    .clk ( clk_1kHz ),
    .enable ( pulse_10ms ),
    .button ( button ),
    .reset ( reset ),
    .out ( seconds_dbnce )
);

always begin
    #500;
    clk_1kHz = ~clk_1kHz;
end

initial begin
    reset = 0;
    button = 0;
    clk_1kHz = 0;

    #100;
    reset = 1;
    #100;
    reset = 0;

    // a bunch of button presses delays that should *not* toggle debouncer
    for ( i = 0; i < 50; i = i+1 ) begin
        #20000;
        button = 1;
        #8000; // 8ms
        button = 0;
    end
    
    button = 0;

    // a bunch of button presses that *should* trigger the debouncer
    for ( i = 0; i < 50; i = i+1 ) begin
        #50000;
        button = ~button;
    end

    $finish;
end


endmodule
