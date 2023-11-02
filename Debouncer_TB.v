`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 09:57:25
// Design Name: 
// Module Name: Debouncer_TB
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


module Debouncer_TB();
    // module in/out ports
    reg IN, CLK, DIV_CLK, RESET;
    wire OUT;
    wire [1:0] STATEVAL; 
    wire [4:0] FREQVAL;
    reg clk; //TestBench clk for simulation

    Debouncer dut(.IN(IN), .CLK(CLK), .DIV_CLK(DIV_CLK), .RESET(RESET), .OUT(OUT), .FREQVAL(FREQVAL), .STATEVAL(STATEVAL), .COUNT_RES(COUNT_RES), .POS_IN(POS_IN));
    
    // initialization
    initial begin
        RESET = 1'b1; #20 RESET = 1'b0;
        clk = 0;
    end

    //generate clock
    always 
        begin
            clk = ~clk; #1; // 2ns clk
        end

    always @(posedge clk)
        begin
            CLK = 0; #10; CLK = 1; #10; //generate the 100ns MHz CLK
        end
    always @(posedge clk)
        begin
            DIV_CLK = 0; #20 DIV_CLK = 1; #20; // generate the 1kHz DIV_CLK
        end

initial
        begin
            IN = 0; #50;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;


            IN = 1; #50;

            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;

            IN = 0; #290;
            
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN; 
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            #3 IN = ~IN;
            IN = 1; #50;

        end   

endmodule
