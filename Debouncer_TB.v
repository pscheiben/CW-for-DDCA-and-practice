`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Glasgow Caledonian University 
// Student: Peter Scheibenhoffer 
// 
// Create Date: 29.10.2023 19:06:05
// Design Name: Verilog-Debouncer Testbench, Behavioral
// Module Name: Debouncer_TB
// Project Name: Timer CW
// Target Devices: Nexys 4 DDR Artix-7 FPGA
// Tool Versions: Vivado 2023.1
// Description: This module is a debouncer for the buttons and make them as a toggle switch    
// 
// Dependencies: 
// 
// Revision: Version 1.3
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Debouncer_TB();
    // module in/out ports
    reg IN, CLK, DIV_CLK, RESET;
    wire OUT;
    reg clk; //TestBench clk for simulation

    Debouncer dut(.IN(IN), .CLK(CLK), .DIV_CLK(DIV_CLK), .RESET(RESET), .OUT(OUT));
    
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
