`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 10:42:02 PM
// Design Name: 
// Module Name: bcd_downcounter
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


module digit_counter(
    input wire clk,
    input wire reset,
    input wire load,
    input wire [WIDTH-1:0] start_count,
    input wire enable,
    output reg [WIDTH-1:0] count, // always a single hex/BCD digit
    output wire term_count
    );
    
parameter DIRECTION = 1'b0; // count up (1) or down (0)
parameter WIDTH = 4;
parameter MAX = 9;
assign term_count = DIRECTION? ( count == MAX ):( count == 0 );

always @(posedge clk, posedge reset) begin
    
    // asynchronous reset
    if (reset) begin
        if ( DIRECTION ) count <= 0;
        else count <= MAX;
    end

    else begin

        // synchronous load
        if ( load ) begin
            count <= start_count;
        end

        else begin 

            if (enable) begin // yes we want to do things

                if ( ~DIRECTION ) begin // direction == 0, count down
                    if (count == 0) count <= MAX;
                    else count <= count - 1;
                end // ~direction

                else begin // direction == 1, counting up
                    if ( count == MAX ) count <= 0;
                    else count <= count + 1;
                end // direction == 1

            end // enable
        end // ~load
    end // ~reset
end


endmodule
