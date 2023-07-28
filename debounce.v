`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 09:35:05 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input button,
    input rst,
    input clk_4Hz,
    output  debounced
    );
    
 wire clk_4Hz ; 
 wire Q1 ; 
 
 DFF A0 (clk_4Hz , button , Q1) ;
 DFF B0 (clk_4Hz , Q1 , Q2 ) ;
 
 
 assign Q2Bar = ~Q2 ;
 assign debounced = Q1 & Q2Bar ; 
 
endmodule
