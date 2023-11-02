`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Glasgow Caledonian University 
// Student: Peter Scheibenhoffer 
// 
// Create Date: 29.10.2023 19:06:05
// Design Name: Timer
// Module Name: Debouncer
// Project Name: 
// Target Devices: Nexys 4 DDR Artix-7 FPGA
// Tool Versions: Vivado 2023.1
// Description: This module is a debouncer for the buttons and make them as a toggle switch    
// 
// Dependencies: 
// 
// Revision: Version 1.00 - File Created
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Debouncer (IN, CLK, DIV_CLK, RESET, OUT, FREQVAL, STATEVAL, COUNT_RES, POS_IN);
    parameter OFF       = 2'b00;
    parameter COUNT_ON  = 2'b01;
    parameter ON        = 2'b10;
    parameter COUNT_OFF = 2'b11;

    

    input IN, CLK, DIV_CLK, RESET;
    output  OUT, COUNT_RES, POS_IN;
    output [1:0] STATEVAL;
    output [4:0] FREQVAL;
    wire [4:0] Freq_40Hz_Count;
    wire Freq_40Hz_Trigger;
    reg [1:0] state = OFF;     // 2 bit for counting states
    reg [1:0] old_state = ON;  // 2 bit for counting old state states, this is required if the button is pressed for a long time
    wire counter_reset;
    reg in_pe_reg, do_reset; //positive edge and negative edge trackker registers, reset the counter
    
    //next state logic
    always@(posedge CLK)
        case (state)
            OFF:        begin
                            do_reset <= 1;                  // reset the counter
                            if( in_pe_reg == 1)   // checks is the Input is high or positive edge occured
                                begin 
                                    state <= COUNT_ON;      // reset counter to start on posedge
                                end
                        end
            COUNT_ON:   begin
                            do_reset <= 0;                  // do not reset the counter anymore, start to count
                            if(Freq_40Hz_Count == 7)        // when the counter reaches the max
                                begin
                                    state <= ON;
                                end
                        end
            ON:         begin
                            do_reset <= 1;
                            if( in_pe_reg == 1)   // checks is the Input is high or positive edge occured
                                begin 
                                    state <= COUNT_OFF;
                                end
                            end
            COUNT_OFF:  begin
                            do_reset <= 0;
                            if(Freq_40Hz_Count == 7)
                                begin
                                    state <= OFF;
                                end
                            
                        end
            default:    state <= OFF; 
        endcase
    
    //counter initialization
    Generic_Counter #   (.COUNTER_WIDTH(5), .COUNTER_MAX(24))
                    Freq_40Hz_Counter (.CLK(CLK), .RESET(counter_reset), .ENABLE_IN(DIV_CLK), .DIR(1'b0), .COUNT(Freq_40Hz_Count), .TRIG_OUT(Freq_40Hz_Trigger));


    //output and combinational logic
        assign OUT = state[0]^state[1];
        assign counter_reset = RESET | do_reset; //resets the counter if reached the max or at RESET

    //posedge handler
    always@(posedge IN)
        begin
            if (state == 2'b00 || state == 2'b10) in_pe_reg <= 1'b1;
            else in_pe_reg <= 1'b0;
        end


    // output assignments to check in the waveform   
    assign FREQVAL = Freq_40Hz_Count;
    assign STATEVAL = state;
    assign COUNT_RES = do_reset;
    assign POS_IN = in_pe_reg;

endmodule
