`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2021 09:15:40 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input wire clk,
    input wire reset,
    output reg pulse // 1-clk long pulse every whateverlong
    );

parameter MAX_COUNT = 5000000;
parameter CTR_WIDTH = 24;

reg [CTR_WIDTH-1:0] count;

always @( negedge clk, posedge reset ) begin

    if ( reset ) begin
        count <= MAX_COUNT;
        pulse <= 0;
    end
    
    else begin
        if ( count == 0 ) begin
            count <= MAX_COUNT;
            pulse <= 1;
        end
        else begin
            count <= count - 1;
            pulse <= 0;
        end
    end
end

endmodule
