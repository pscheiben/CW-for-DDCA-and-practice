`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Glasgow Caledonian University 
// Student: Peter Scheibenhoffer 
// 
// Create Date: 26.10.2023 15:00:45
// Design Name: 
// Module Name: Timer_Wrapper
// Project Name: CW1 - Timer
// Target Devices: Digilent CMOD-A7 Artix 7 35T
// Tool Versions: Vivado 2023.1
// Description: mm.ss format timer, with a function of up and down counting and extra 3 features
// 
// Dependencies: 
// 
// Revision: Version 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrapper(CLK, RESET, DIR_IN, ENABLE, SEG_SELECT, DEC_OUT, INDICATOR, RGB_LED //take out ENABLE, put in DIR_IN
    );
    
    input CLK, RESET, DIR_IN, ENABLE;
    output [3:0] SEG_SELECT;
    output [7:0] DEC_OUT;
    output INDICATOR; //if the counting is reached the max, this is a carry
    output [2:0] RGB_LED; // RED = 100, GREEN = 010, BLUE = 001

    wire Bit17TriggOut;
    wire [16:0]Bit17Count;
    wire [1:0] Bit2CounterControl;
    wire Bit4TriggOutBase, Bit4TriggOut0, Bit4TriggOut1, Bit4TriggOut2, Bit4TriggOut3;
    wire [4:0] Bit4CountValueDot0, Bit4CountValueDot1, Bit4CountValueDot2, Bit4CountValueDot3, Bit4CountValueDot4, Bit4CountValueDot5;
    wire [3:0] Bit4CountValue0, Bit4CountValue1, Bit4CountValue2, Bit4CountValue3, Bit4CountValue4, Bit4CountValue5;
    wire [4:0] Mux4Out;
    wire Enableand, DIR;


    Generic_Counter #   (.COUNTER_WIDTH(17), .COUNTER_MAX(11999))
                        Bit17Counter (.CLK(CLK), .RESET(1'b0), .ENABLE_IN(1'b1), .DIR(1'b0), .COUNT(Bit17Count), .TRIG_OUT(Bit17TriggOut));


    Generic_Counter #   (.COUNTER_WIDTH(2), . COUNTER_MAX(3))
                        Bit2Counter (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit17TriggOut), .DIR(1'b0), .COUNT(Bit2CounterControl));
    

    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                    Bit4CounterBase (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Enableand), .DIR(DIR), .TRIG_OUT(Bit4TriggOutBase));

    
    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                    Bit4Counter0 (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit4TriggOutBase), .DIR(DIR), .COUNT(Bit4CountValue0), .TRIG_OUT(Bit4TriggOut0));

    
    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                    Bit4Counter1 (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit4TriggOut0), .DIR(DIR), .COUNT(Bit4CountValue1), .TRIG_OUT(Bit4TriggOut1));


    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                    Bit4Counter2 (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit4TriggOut1), .DIR(DIR), .COUNT(Bit4CountValue2), .TRIG_OUT(Bit4TriggOut2));

    
    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(5))
                    Bit4Counter3 (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit4TriggOut2), .DIR(DIR), .COUNT(Bit4CountValue3), .TRIG_OUT(Bit4TriggOut3));


    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                    Bit4Counter4 (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit4TriggOut3), .DIR(DIR), .COUNT(Bit4CountValue4), .TRIG_OUT(Bit4TriggOut4));


    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(5))
                    Bit4Counter5 (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Bit4TriggOut4), .DIR(DIR), .COUNT(Bit4CountValue5), .TRIG_OUT(Bit4TriggOut5));

            
    Mux4 Mux4(.CONTROL(Bit2CounterControl), .IN0(Bit4CountValueDot2), .IN1(Bit4CountValueDot3), .IN2(Bit4CountValueDot4), .IN3(Bit4CountValueDot5), .OUT(Mux4Out));


    seven_seg seven_seg(.x(Mux4Out[3:0]), .SEG_SELECT_IN(Bit2CounterControl), .dot(Mux4Out[4]), .cat(SEG_SELECT), .seg(DEC_OUT));

    //feed with a devided clock, otherwise, bouncing occurs. Switch is active low, that is why INPUT(~) logic
    TSM Direction (.CLK(Bit17TriggOut), .INPUT(~DIR_IN), .RESET(RESET), .TOUT(DIR)); 

    assign INDICATOR = Bit4TriggOut5;

    assign Bit4CountValueDot2 = {1'b0, Bit4CountValue2};
    assign Bit4CountValueDot3 = {1'b0, Bit4CountValue3};
    assign Bit4CountValueDot4 = {1'b1, Bit4CountValue4};
    assign Bit4CountValueDot5 = {1'b0, Bit4CountValue5};
    assign Enableand = ~ENABLE & Bit17TriggOut;  //"not" logic because it is a button, now it change from ~ENABLE to 1'b1
    assign RGB_LED[2:1] = 2'b11; //turn of the RGB leds
    assign RGB_LED[0] = DIR;
    
endmodule
