`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 01:18:01 PM
// Design Name: 
// Module Name: cooktime_count
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


module cooktime_count(
    input wire clk,
    input wire button_in, // set the button register
    input wire main_enable,
    input wire reset,
    // current timer output
    output wire [3:0] ones,
    output wire [3:0] tens
    );

parameter TIMER_DIRECTION = 1'b1;

// increment the counter once per button press
reg increment, increment_done;
always @( posedge clk, posedge reset ) begin
    if ( reset ) begin
        increment <= 0;
        increment_done <= 0;
    end
    else begin
        if ( button_in & ~increment_done ) begin
            increment <= 1;
            increment_done <= 1;
        end
        else if ( button_in & increment_done ) begin
            increment <= 0;
            increment_done <= 1;
        end
        else begin // ~button_in
            increment = 0;
            increment_done = 0;
        end
    end //~reset
end

// main counters
wire ones_enable, ones_max;
//assign ones_enable = increment & main_enable;
defparam ones_ctr.MAX = 9;
defparam ones_ctr.DIRECTION = TIMER_DIRECTION; // countdown
digit_counter ones_ctr(
    .clk ( clk ),
    .enable ( increment & main_enable ),
    .reset (reset),
    .load ( 0 ),
    .start_count ( 0 ),
    .count ( ones ),
    .term_count ( ones_max )
);

wire tens_enable, tens_max;
//assign tens_enable = increment & ones_max & main_enable;
defparam tens_ctr.MAX = 5;
defparam tens_ctr.DIRECTION = TIMER_DIRECTION;
digit_counter tens_ctr(
    .clk ( clk ),
    .enable (  increment & ones_max & main_enable ),
    .reset (reset),
    .load ( 0 ),
    .start_count ( 0 ),
    .count ( tens ),
    .term_count ( tens_max )
);

endmodule
