`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 07:34:20 PM
// Design Name: 
// Module Name: VGA_counter
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


module VGA_counter(
    input clk_100MHz,
    input reset,        // reset game
    output video_on,    // on when pixel val of x and y are within display area 640x480
    output hsync,       // horizontal sync
    output vsync,       // vertical sync
    output p_tick,      // the 25MHz pixel/second rate signal
    output [9:0] x,     // horizontal x value max 0-799
    output [9:0] y      // vertical y value max 0-524
    );
    //X width
    parameter HD = 640;             // horizontal visible display area
    parameter HF = 48;              // horizontal front porch width
    parameter HB = 16;              // horizontal back porch width
    parameter HR = 96;              // horizontal retrace
    parameter HMAX = HD+HF+HB+HR-1; // max value of horizontal X (799)
    // Y length
    parameter VD = 480;             // vertical visible display area
    parameter VF = 10;              // vertical front porch length 
    parameter VB = 33;              // vertical back porch lenght
    parameter VR = 2;               // vertical retrace
    parameter VMAX = VD+VF+VB+VR-1; // max value of veritcal y (524)  
    
    // *** 25MHz clk using 100MHz *********************************************************
	reg  [1:0] r_25MHz;
	wire w_25MHz;
	
	always @(posedge clk_100MHz or posedge reset)
		if(reset)
		  r_25MHz <= 0;
		else
		  r_25MHz <= r_25MHz + 1;
	
	assign w_25MHz = (r_25MHz == 0) ? 1 : 0; // assert tick 1/4 of the time
    // ****************************************************************************************
    
    // Counter Registers, two each for buffering to avoid glitches
    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;
    
    // Output Buffers
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;
    
    // Register Control
    always @(posedge clk_100MHz or posedge reset)
        if(reset) begin
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg  <= 1'b0;
            h_sync_reg  <= 1'b0;
        end
        else begin
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg  <= v_sync_next;
            h_sync_reg  <= h_sync_next;
        end
         
    //horizontal counter
    always @(posedge w_25MHz or posedge reset)      // refresh rate
        if(reset)
            h_count_next = 0;
        else
            if(h_count_reg == HMAX)                 // done counting horizontal pixels
                h_count_next = 0;
            else
                h_count_next = h_count_reg + 1;         
  
    //vertical counter
    always @(posedge w_25MHz or posedge reset)
        if(reset)
            v_count_next = 0;
        else
            if(h_count_reg == HMAX)                 // done counting horizontal pixels
                if((v_count_reg == VMAX))           // done counting vertical pixels
                    v_count_next = 0;
                else
                    v_count_next = v_count_reg + 1;
        
    // h_sync_next for horizontal retrace
    assign h_sync_next = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
    
    // v_sync_next for vertical retrace
    assign v_sync_next = (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));
    
    // pixel values are within the display area
    assign video_on = (h_count_reg < HD) && (v_count_reg < VD); // 0-639 and 0-479 respectively
            
    // Outputs
    assign hsync  = h_sync_reg;
    assign vsync  = v_sync_reg;
    assign x      = h_count_reg;
    assign y      = v_count_reg;
    assign p_tick = w_25MHz;
            
endmodule