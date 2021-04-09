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
        input wire blink_pulse, // timing for the blinky light
        input wire [7:0] bargraph,
        // control outputs
        output wire increment_seconds,
        output wire increment_minutes,
        output reg prog_mode, // allow counting in the setting counters
        output wire timer_enabled_led, // solid light
        output wire timer_on_led, // blinky light
        output reg main_timer_enable, // allow counter in the main timer
        output reg load_timer, // load the main timer with the values on the setting ctrs
        output reg [7:0] output_leds // eight blinking/bargraph lights
    );

// blinky light for timer on LED
reg flash;
always @( posedge clk, posedge reset ) begin
    if ( reset ) flash <= 0;
    else begin
        if ( blink_pulse ) flash <= ~flash;
    end
end

// main control state machine
parameter PROG = 3'b001;
parameter TIMER = 3'b100;
parameter DONE = 3'b010;
parameter LOAD = 3'b011;
parameter RESET = 3'b000;
reg [3:0] state, next_state;

// basic machine drive
always @( posedge clk, posedge reset ) begin
    if ( reset ) state <= RESET;
    else state <= next_state;
end

// next state calculations
always @( state, cooktime_req, start_timer, timer_done ) begin
    case ( state )
        RESET: begin
            if ( cooktime_req ) next_state = PROG;
            else next_state = RESET;
        end
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
always @ ( state, timer_en, bargraph, flash ) begin
    case ( state )
        RESET: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 0;
            output_leds = 0;
        end
        PROG: begin
            prog_mode = 1;
            main_timer_enable = 0;
            load_timer = 0;
            output_leds = 0;
        end
        TIMER: begin
            prog_mode = 0;
            main_timer_enable = timer_en;
            load_timer = 0;
            output_leds = bargraph;
        end 
        LOAD: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 1;
            output_leds = 0;
        end
        DONE: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 0;
            output_leds = {8{flash}};
        end
        default: begin
            prog_mode = 0;
            main_timer_enable = 0;
            load_timer = 0;
            output_leds = 0;
        end
    endcase
end

assign timer_enabled_led = main_timer_enable; // not programming or done
assign timer_on_led = main_timer_enable & flash;

assign increment_seconds = cooktime_req & seconds_req;
assign increment_minutes = cooktime_req & minutes_req;

endmodule
