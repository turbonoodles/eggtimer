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
    output wire pulse // 1-clk long pulse every whateverlong
    );

parameter MAX_COUNT = 5000000;
parameter CTR_WIDTH = 24;

reg [CTR_WIDTH-1:0] count;

always @( negedge clk, posedge reset ) begin

    if ( reset ) count <= MAX_COUNT;
    
    else begin
        if ( count == 0 ) count <= MAX_COUNT;
        else count <= count - 1;
    end
end

// output pulse
assign pulse = ( count == 0 ); // this probably synthesizes to ~|count?

endmodule
