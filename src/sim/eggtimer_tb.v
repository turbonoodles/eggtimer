module eggtimer_tb();

reg clk_1Hz;
reg clk_500Hz;

// instantiate the display 
quad_sevenseg display (
    .clk ( clk_500Hz ),
    .digit0 ( seconds ),
    .digit1 ( ten_seconds ),
    .digit2 ( minutes ),
    .digit3 ( ten_minutes )
);




endmodule