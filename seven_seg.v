`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2023 00:43:07
// Design Name: 
// Module Name: seven_seg
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


module seven_seg(
        input [3:0] x,          
        input [1:0] SEG_SELECT_IN,          //  input that tells the module which digit to light up
        input dot,
        output reg [3:0] cat,
        output reg [7:0] seg  
    );

    always @ (SEG_SELECT_IN) 
    begin
    case(SEG_SELECT_IN)
                     //0123 segment
        2'b00: cat = 4'b0111;
        2'b01: cat = 4'b1011;
        2'b10: cat = 4'b1101;
        2'b11: cat = 4'b1110;
        default: cat = 4'b1111;
    
    endcase
    
    // switch case depending on input x: assigns which segments should light up
    case(x)
//           Segment: abcdefg not this 
                  //  gfedcba
        4'h0: seg =7'b0111111;
        4'h1: seg =7'b0000110;
        4'h2: seg =7'b1011011;
        4'h3: seg =7'b1001111;
        4'h4: seg =7'b1100110;
        4'h5: seg =7'b1101101;
        4'h6: seg =7'b1111101;
        4'h7: seg =7'b0000111;
        4'h8: seg =7'b1111111;
        4'h9: seg =7'b1101111;
        default: seg =7'b0000000;   // cases from 10 to 15 keep all the segments OFF
                                    // as only nr 0->9 can be displayed per 1 digit
      
            
    endcase
    
    seg[7] = dot ? 1:0;  // ternery if dot high light up the dot
    end
endmodule
