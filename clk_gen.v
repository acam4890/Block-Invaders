`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 09:25:47 AM
// Design Name: 
// Module Name: clk_gen
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


module clk_gen(
    input clk,
    input reset ,
    output reg clk_4Hz,
    output clk_25M
    );
 reg [20:0] counter1;
 
 clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_25M(clk_25M),     // output clk_5M
    .clk_5M(clk_5M),     // output clk_25M
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);
    always @(posedge clk_5M) begin
    if (reset == 1) begin 
        counter1 <= 0; end 
    else begin 
       counter1 <= counter1+1 ;
        if (counter1 == 624999) begin 
            counter1 <= 0 ;
            clk_4Hz <= ~clk_4Hz ; end 
        else begin 
            clk_4Hz <= clk_4Hz ; end 
         end
end
endmodule
