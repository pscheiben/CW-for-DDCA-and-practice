`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Glasgow Caledonian University 
// Student: Peter Scheibenhoffer 
// 
// Create Date: 26.10.2023 15:00:45
// Design Name: 
// Module Name: Toggle-State Module
// Project Name: CW1 - Timer
// Target Devices: Digilent CMOD-A7 Artix 7 35T
// Tool Versions: Vivado 2023.1
// Description: Initial state is 0 and toggles when button is pushed
// 
// Dependencies: 
// 
// Revision: Version 1.0
// Revision 0.01 - File Created
// Additional Comments:

//////////////////////////////////////////////////////////////////////////////////


module TSM(CLK, INPUT, RESET, TOUT);
        input CLK, INPUT, RESET;
        output reg TOUT;

    always @ (posedge CLK)
    begin
        if(RESET)
            TOUT <= 1'b0; // RESET the state
        else
            TOUT <= TOUT^INPUT;  // if RESET is not pushed, the OUT value toggle if INPUT is 1
    end

endmodule
