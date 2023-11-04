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
// Tool Versions: Vivado 2023.1 / Visual Studio Code
// Description: mm.ss format timer, with a function of up and down counting and extra 3 features
// Still in progress, but the main function is working
// Dependencies: 
// 
// Revision: Version 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrapper(CLK, RESET, DIR_IN, ENABLE, SEG_SELECT, DEC_OUT, INDICATOR, BTNL, BTNR, RGB_LED //ports list
    );
    
    input CLK, RESET, DIR_IN, ENABLE, BTNL, BTNR;   //standard ports for input
    output [3:0] SEG_SELECT;            // *does not apply! 3 bit long, to able to turn off the upper 4 segment on nexys board
    output [7:0] DEC_OUT;               
    output [1:0] INDICATOR;                   //if the counting is reached the max, this is a carry
    output [2:0] RGB_LED;               //RGB LED output

    // CLK Divider 1ms, trigger and counter
    wire Freq_10kHz_Trigger;
    wire [14:0]Freq_10kHz_Count;

    // Seven Segment control and mux control
    wire [1:0] Segment_Control;
    
    //Dot position, Dot control
    wire [1:0] Dot_Pos;
    
    // Different timers counters and triggers, 10ms, 100ms, 1s, 10s, 1min, 10min
    // lots of wires, for later use
    wire Counter_1ms_Trig, Counter_10ms_Trig, Counter_100ms_Trig, Counter_1sec_Trig, Counter_10sec_Trig, Counter_1min_Trig, Counter_10min_Trig, Counter_1hour_Trig;
    wire [4:0] Mux_IN_0, Mux_IN_1, Mux_IN_2, Mux_IN_3;
    wire [3:0] Counter_1ms_Value, Counter_10ms_Value, Counter_100ms_Value, Counter_1sec_Value, Counter_10sec_Value, Counter_1min_Value, Counter_10min_Value, Counter_1hour_Value;
    
    // Mux for the seven segment
    wire [4:0] Mux4Out;
    
    //demux for dot
    wire [3:0]Dot_Demux;
    
    // Enabler for the counter chain and debouncer output for direction switch
    wire Enable_and_Clk, Indicator_Wire, Toggled_Direction, Debounced_Direction;
    
    //Timer setting state
    wire [1:0] Timer_State;
    // Initializations of the counters for the digital clock, 1ms, 10ms, 100ms, 1s, 10s, 1min, 10min, 1hour are used for later options
    Generic_Counter #   (.COUNTER_WIDTH(11), .COUNTER_MAX(1199))
                        Freq_10kHz_Counter (.CLK(CLK), .RESET(1'b0), .ENABLE_IN(1'b1), .DIR(1'b0), .COUNT(Freq_10kHz_Count), .TRIG_OUT(Freq_10kHz_Trigger));
        

    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                        Counter_1ms (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Enable_and_Clk), .DIR(Debounced_Direction), .COUNT(Counter_1ms_Value), .TRIG_OUT(Counter_1ms_Trig));

    
    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                        Counter_10ms (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_1ms_Trig), .DIR(Debounced_Direction), .COUNT(Counter_10ms_Value), .TRIG_OUT(Counter_10ms_Trig));

    
    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                        Counter_100ms (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_10ms_Trig), .DIR(Debounced_Direction), .COUNT(Counter_100ms_Value), .TRIG_OUT(Counter_100ms_Trig));


    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                        Counter_1sec (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_100ms_Trig), .DIR(Debounced_Direction), .COUNT(Counter_1sec_Value), .TRIG_OUT(Counter_1sec_Trig));

    
    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                        Counter_10sec (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_1sec_Trig), .DIR(Debounced_Direction), .COUNT(Counter_10sec_Value), .TRIG_OUT(Counter_10sec_Trig));


    Generic_Counter #   (.COUNTER_WIDTH(3), .COUNTER_MAX(5))
                        Counter_1min (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_10sec_Trig), .DIR(Debounced_Direction), .COUNT(Counter_1min_Value), .TRIG_OUT(Counter_1min_Trig));


    Generic_Counter #   (.COUNTER_WIDTH(4), .COUNTER_MAX(9))
                        Counter_10min (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_1min_Trig), .DIR(Debounced_Direction), .COUNT(Counter_10min_Value), .TRIG_OUT(Counter_10min_Trig));

    
    Generic_Counter #   (.COUNTER_WIDTH(3), .COUNTER_MAX(5))
                        Counter_1hour (.CLK(CLK), .RESET(RESET), .ENABLE_IN(Counter_10min_Trig), .DIR(Debounced_Direction), .COUNT(Counter_1hour_Value), .TRIG_OUT(Counter_1hour_Trig));
                    
                    
    Generic_Counter #   (.COUNTER_WIDTH(2), . COUNTER_MAX(3))
                        Segment_Control_Sync (.CLK(CLK), .RESET(1'b0), .ENABLE_IN(Freq_10kHz_Trigger), .DIR(1'b0), .COUNT(Segment_Control));


    // Mux for the seven segment
    Mux4 Segment_Control_Mux(.CONTROL(Segment_Control), .IN0(Mux_IN_0), .IN1(Mux_IN_1), .IN2(Mux_IN_2), .IN3(Mux_IN_3), .OUT(Mux4Out));
    
    
    //DeMux for dot, not working constant is used for now
    // DotLogic Dot_Control_Logic_2(.CLK(Counter_1ms_Trig), .RESET(RESET), .DIR(Dot_Pos), .OUT(Timer_State));
    // DeMux4 Dot_Control_Mux(.CONTROL(Timer_State), .OUT(Dot_Demux));
    assign Dot_Demux = 4'b0100;
    
    // Debouncer Rot_Left_Debouncer(.IN(BTNL), .CLK(CLK), .DIV_CLK(Counter_1ms_Trig), .RESET(RESET),  .OUT(Dot_Pos[1]));
    // Debouncer Rot_Right_Debouncer(.IN(BTNR), .CLK(CLK), .DIV_CLK(Counter_1ms_Trig), .RESET(RESET),  .OUT(Dot_Pos[0]));




    // Seven segment display
    seven_seg Seven_Seg_Dec(.x(Mux4Out[3:0]), .SEG_SELECT_IN(Segment_Control), .dot(Mux4Out[4]), .cat(SEG_SELECT), .seg(DEC_OUT));


    // just an indicator trigger every sec
    TSM Not_so_Useful_Feature(.CLK(CLK), .INPUT(Counter_1sec_Trig), .RESET(RESET), .TOUT(Indicator_Wire));

    Debouncer Direction_Deboncer(.IN(~DIR_IN), .CLK(CLK), .DIV_CLK(Counter_1ms_Trig), .RESET(RESET),  .OUT(Debounced_Direction));

    // TSM ROT_SW_Toggler(.CLK(CLK), .INPUT(Debounced_Direction), .RESET(RESET), .TOUT(Toggled_Direction));
    


    assign INDICATOR[1] = Debounced_Direction;
    assign INDICATOR[0] = Indicator_Wire;
    assign RGB_LED[0] = 1'b1;
    assign RGB_LED[1] = 1'b1;
    assign RGB_LED[2] = 1'b1;
    // dot place after the second segment
    assign Mux_IN_0 = {Dot_Demux[0], Counter_10sec_Value};
    assign Mux_IN_1 = {Dot_Demux[1], Counter_1min_Value};
    assign Mux_IN_2 = {Dot_Demux[2], Counter_10min_Value};
    assign Mux_IN_3 = {Dot_Demux[3], Counter_1hour_Value};
    
    assign Enable_and_Clk = ~ENABLE & Freq_10kHz_Trigger;  //"not" logic because it is a button on the other board CMOD-A7

    
endmodule