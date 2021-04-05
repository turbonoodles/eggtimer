`timescale 1us / 1ns

module eggtimer_tb();

reg timer_en;
reg reset; // no need to debounce reset
reg cooktime_btn;
reg start_btn;
reg minutes_btn;
reg seconds_btn;
reg clk_1kHz;
wire [6:0] display_cathodes;
wire [7:0] display_anodes;
wire timer_enabled_led;
wire timer_on_led;

reg [31:0] i; // testbench index thing

// generate pulses every 1s for synchronous counters
wire pulse_1s;
defparam timer_1s.MAX_COUNT = 999; // accuracy matters here
defparam timer_1s.CTR_WIDTH = 23; // need 23b to hold 5 000 000
clock_divider timer_1s(
    .clk (clk_1kHz),
    .reset (reset),
    .pulse (pulse_1s)
);

// 2ms clock enable signal for 500Hz display refresh
wire pulse_2ms;
defparam timer_2ms.MAX_COUNT = 4;
defparam timer_2ms.CTR_WIDTH = 12; // 2^11 = 2048
clock_divider timer_2ms(
    .clk (clk_1kHz),
    .reset (reset),
    .pulse (pulse_2ms)
);

// pulse every 10ms - clock enable signal for debouncers
wire pulse_10ms;
defparam timer_10ms.MAX_COUNT = 10;
defparam timer_10ms.CTR_WIDTH = 14; // 2^14 = 16 384
clock_divider timer_10ms(
    .clk (clk_1kHz),
    .reset (reset),
    .pulse (pulse_10ms)
);

wire cooktime_req; // request to enter cook time mode
debouncer cooktime_debouncer(
    .clk ( clk_1kHz ),
    .enable ( pulse_10ms ),
    .button ( cooktime_btn ),
    .reset ( reset ),
    .out ( cooktime_req )
);

wire minutes_dbnce;
debouncer minutes_debouncer(
    .clk ( clk_1kHz ),
    .enable ( pulse_10ms ),
    .button ( minutes_btn ),
    .reset ( reset ),
    .out ( minutes_dbnce )
);

wire seconds_dbnce;
debouncer seconds_debouncer(
    .clk ( clk_1kHz ),
    .enable ( pulse_10ms ),
    .button ( seconds_btn ),
    .reset ( reset ),
    .out ( seconds_dbnce )
);

wire [3:0] seconds_count, tens_seconds_count, minutes_count, tens_minutes_count;
wire [3:0] seconds_prog, tens_seconds_prog, minutes_prog, tens_minutes_prog;
time_count main_timer(
    .clk (clk_1kHz),
    .reset (reset),
    .count_enable ( pulse_1s ),
    .main_enable ( timer_on ),
    .load ( load_main_timer ),
    // cook time settings
    .seconds_prog ( seconds_prog ),
    .tens_seconds_prog ( tens_seconds_prog ),
    .minutes_prog ( minutes_prog ), 
    .tens_minutes_prog ( tens_minutes_prog ),
    // timer outputs
    .seconds ( seconds_count ),
    .tens_seconds ( tens_seconds_count ),
    .minutes ( minutes_count ),
    .tens_minutes ( tens_minutes_count ),
    .done ( timer_done )
);

// individual counters for minutes and seconds to allow setting individually
cooktime_count seconds_set(
    .clk ( clk_1kHz ),
    .button_in ( increment_seconds ),
    .main_enable ( prog_mode ),
    .reset ( reset ),
    // set time outputs
    .ones ( seconds_prog ),
    .tens ( tens_seconds_prog )
);

cooktime_count minutes_set(
    .clk ( clk_1kHz ),
    .button_in ( increment_minutes ),
    .main_enable ( prog_mode ),
    .reset ( reset ),
    // set time outputs
    .ones ( minutes_prog ),
    .tens ( tens_minutes_prog )
);

// main controller
// - allow setting time when in time setting mode and holding button 
// - load time from set counters when transistioning to countdown timer mode
main_control controller(
    .clk ( clk_1kHz),
    .reset ( reset ),
    .cooktime_req ( cooktime_req ), // debounced button
    .start_timer ( start_btn ),
    .seconds_req ( seconds_dbnce ),
    .minutes_req ( minutes_dbnce ),
    .timer_en ( timer_en ), // switch input
    .timer_done ( timer_done ),

    .increment_seconds ( increment_seconds ),
    .increment_minutes ( increment_minutes ),
    .prog_mode ( prog_mode ),
    .timer_enabled_led ( timer_enabled_led ),
    .timer_on_led ( timer_on_led ),
    .main_timer_enable ( timer_on ),
    .load_timer ( load_main_timer )
);

// display mux
// prog_mode will be high if we are displaying the set time
wire [3:0] seconds, tens_seconds, minutes, tens_minutes;
assign seconds = prog_mode? seconds_prog:seconds_count;
assign tens_seconds = prog_mode? tens_seconds_prog:tens_seconds_count;
assign minutes = prog_mode? minutes_prog:minutes_count;
assign tens_minutes = prog_mode? tens_minutes_prog:tens_minutes_count;

// display instantiation
quad_sevenseg display(
    .clk (clk_1kHz),
    .clk_enable (pulse_2ms),
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
    clk_1kHz = 0;
    reset = 0;
    timer_en = 0;
    cooktime_btn = 0;
    minutes_btn = 0;
    seconds_btn = 0;
    start_btn = 0;

    #100;
    reset = 1;
    #100;
    reset = 0;

    // press seconds/minutes a few times; nothing should happen
    for ( i = 0; i < 10; i = i+1 ) begin
        #20000;
        minutes_btn = ~minutes_btn;
    end
    minutes_btn = 0;
    #1000;
    for ( i = 0; i < 10; i = i+1 ) begin
        #20000;
        seconds_btn = ~seconds_btn;
    end
    seconds_btn = 0;
    #1000;

    // go into cooktime mode
    cooktime_btn = 1;
    #20000; // lots of time to get through debouncer
    cooktime_btn = 0;
    #1000;
    // nothing happens: not holding the button
    for ( i = 0; i < 10; i = i+1 ) begin
        #20000;
        minutes_btn = ~minutes_btn;
    end
    minutes_btn = 0;
    #1000;
    for ( i = 0; i < 10; i = i+1 ) begin
        #20000;
        seconds_btn = ~seconds_btn;
    end
    seconds_btn = 0;
    #1000;

    cooktime_btn = 1;
    // *now* stuff happens
    for ( i = 0; i < 10; i = i+1 ) begin
        #20000;
        minutes_btn = ~minutes_btn;
    end
    minutes_btn = 0;
    #1000;
    for ( i = 0; i < 10; i = i+1 ) begin
        #20000;
        seconds_btn = ~seconds_btn;
    end
    seconds_btn = 0;
    #1000;
    cooktime_btn = 0;
    #1000;

    // start timer
    start_btn = 1;
    #20000;
    start_btn = 0;
    #20000;
    timer_en = 1;
    #100000000;

    $finish;
    

end

endmodule