`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2021 10:21:47 AM
// Design Name: 
// Module Name: main_control
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


module main_control(
        // control inputs
        input wire clk,
        input wire reset, 
        input wire cooktime_req, // cook time button/holdy button = switch
        input wire start_timer, // timer start button
        input wire timer_en, // timer enable switch
        input wire timer_done, // timer has reached zero
        input wire seconds_req, // user seconds increment request
        input wire minutes_req, // ditto for minutes

        // control outputs
        output wire increment_seconds,
        output wire increment_minutes,
        output reg prog_mode, // allow counting in the setting counters
        output wire timer_enabled_led, // solid light
        output wire timer_on_led, // blinky light
        output reg main_timer_enable, // allow counter in the main timer
        output reg load_timer // load the main timer with the values on the setting ctrs
    );

// blinky light for timer on LED
reg flash;
always @( posedge clk, posedge reset ) begin
    if ( reset ) flash <= 0;
    else if ( main_timer_enable ) flash <= ~flash;
end

// main control state machine
parameter PROG = 2'b01;
parameter TIMER = 2'b00;
parameter DONE = 2'b10;
parameter LOAD = 2'b11;
reg [2:0] state, next_state;

// basic machine drive
always @( posedge clk, posedge reset ) begin
    if ( reset ) state <= TIMER;
    else state <= next_state;
end

// next state calculations
always @( state, cooktime_req, start_timer, timer_done ) begin
    case ( state )
        PROG: begin // time setting mode
            if ( start_timer ) next_state = LOAD;
            else next_state = PROG;
        end
        DONE: begin // timer has reached its end
            if ( cooktime_req ) next_state = PROG;
            else if ( start_timer ) next_state = LOAD;
            else next_state = DONE;
        end
        TIMER: begin // counting down
            if ( cooktime_req ) next_state = PROG;
            else if ( timer_done ) next_state = DONE;
            else next_state = TIMER;
        end 
        LOAD: next_state = TIMER; // load the timer with a setting
        default: next_state = DONE;
    endcase
end

// output decoding
always @ ( state, timer_en ) begin
    case ( state )
        PROG: begin
            prog_mode = 1;
            main_timer_enable = 0;
            load_timer = 0;
        end
        TIMER: begin
            prog_mode = 0;
            main_timer_enable = timer_en;
            load_timer = 0;
        end 
        LOAD: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 1;
        end
        DONE: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 0;
        end
        default: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 0;
        end
    endcase
end

assign timer_enabled_led = main_timer_enable; // not programming or done
assign timer_on_led = main_timer_enable & flash;

assign increment_seconds = cooktime_req & seconds_req;
assign increment_minutes = cooktime_req & minutes_req;

endmodule
