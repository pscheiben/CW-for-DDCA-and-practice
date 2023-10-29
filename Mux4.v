`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 23:53:19
// Design Name: 
// Module Name: Mux4
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


module Mux4(
    
        input [1:0] CONTROL,
        input [4:0] IN0, IN1, IN2, IN3,
        output reg [4:0] OUT
    );


    always@ (*) 
    begin
            case (CONTROL)
                2'b00       : OUT <= IN0;
                2'b01       : OUT <= IN1;
                2'b10       : OUT <= IN2;
                2'b11       : OUT <= IN3;
                default     : OUT <= 5'b00000;
            endcase
    end  

endmodule
