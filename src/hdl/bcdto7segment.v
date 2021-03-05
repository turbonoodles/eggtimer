`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2021 12:48:01 PM
// Design Name: 
// Module Name: bcdto7segment
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


module bcdto7segment(
    input wire [3:0] bcd_in, // bcd input number; MSB in 3
    output wire [6:0] seg // segment outputs, a-g
    );

// nicer internal representation so the segments are kinda legible
// bcd number will be abcd
wire a, b, c, d;
assign a = bcd_in[3];
assign b = bcd_in[2];
assign c = bcd_in[1];
assign d = bcd_in[0];

// segment equations
// inverted sum-of-products because I'm a dummy & didn't notice active-low
assign seg[0] = ~( a | c | ( b & d ) | ( ~b & ~d ) ); // segment a
assign seg[1] = ~( ~b | ( c & d ) | ( ~c & ~d )); // segment b
assign seg[2] = ~( b | ~c | d ); // segment c
assign seg[3] = ~( a | (c & ~d) | (~b & (c | ~d)) | (b & ~c & d) ); // segment d
assign seg[4] = ~( ( c & ~d ) | ( ~b & ~d )); // segment e 
assign seg[5] = ~( a | (~c & ~d) | (b & ~c) | (b & ~d) ); // segment f
assign seg[6] = ~( a | (b & ~c) | (~b & c) | (c & ~d)); // segment g

endmodule