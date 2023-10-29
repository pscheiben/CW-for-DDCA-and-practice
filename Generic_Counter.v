`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute:  Glasgow Caledonian University
// Student: Peter Scheibenhoffer 
// 
// Create Date: 26.10.2023 14:32:04
// Design Name: 
// Module Name: Generic_Counter
// Project Name: Decimal_Counter
// Target Devices: Digilent CMOD-A7
// Tool Versions: Vivado 2023.1 ML
// Description: Create a parameterizable counter
// 
// Dependencies: 
// 
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Generic_Counter(CLK, RESET, ENABLE_IN, DIR, TRIG_OUT, COUNT
    );
    // default case, most used
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX = 9;

    input CLK, RESET, DIR, ENABLE_IN;
    output TRIG_OUT;
    output [COUNTER_WIDTH-1:0] COUNT;

    reg [COUNTER_WIDTH-1:0] counter_value;
    reg Trigger_out;

// Synchronous logic for counter_value
    always@(posedge CLK) begin
        if(DIR == 1'b0) begin
            if(RESET)
                counter_value <= 0;
            else begin
                if (ENABLE_IN) begin
                    if(counter_value == COUNTER_MAX)
                        counter_value <= 0;
                    else
                        counter_value <= counter_value + 1;
                    end
                end
        end
        else begin
            if(RESET)
                counter_value <= COUNTER_MAX;
            else begin
                if (ENABLE_IN) begin
                    if(counter_value == 0)
                        counter_value <= COUNTER_MAX;
                    else
                        counter_value <= counter_value - 1;
                    end
                end           
        end
    end

// Synchronous logic for Trigger_out
    always@(posedge CLK) begin
        if(DIR == 1'b0) begin
            if(RESET)
                Trigger_out <=0;
            else begin
                if (ENABLE_IN && (counter_value == COUNTER_MAX))
                    Trigger_out <= 1;
                else
                    Trigger_out <= 0;
            end
        end    
        else begin
            if(RESET)
                Trigger_out <=0;
            else begin
                if (ENABLE_IN && (counter_value == 0))
                    Trigger_out <= 1;
                else
                    Trigger_out <= 0;
            end
        end
    end

// Assignments that tie the counter_value and Trigger_out to COUNT and TRIG_OUT respectively
    assign COUNT = counter_value;
    assign TRIG_OUT = Trigger_out;
    
endmodule
