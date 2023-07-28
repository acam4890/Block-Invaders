`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 07:49:46 PM
// Design Name: 
// Module Name: VGA_gen
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


module VGA_gen(
    input left, right, shoot,
	input clk_100MHz,      // from Basys 3
	input reset,
	output hsync, 
	output vsync,
	output [11:0] rgb      // 12 FPGA pins for RGB(4 per color)
);
	
	// Signal Declaration
    wire wire_video, wire_ptick;
    wire wireL_debounced, wirer_debounced, wireshoot_debounced;
    wire clk_4Hz, clk_25M;
    wire wireship_on;
    wire [9:0] wire_x, wire_y;
    reg [11:0] rgb_reg;
    wire[11:0] rgb_next;
    wire [9:0] laserleft,laserright,lasertop,laserbot;
    wire ship_shot ;
    wire laser_shot;
    // Instantiate VGA Controller
    clk_gen C0(.clk(clk_100MHz), .reset(reset), .clk_4Hz(clk_4Hz), .clk_25M(clk_25M));
    debounce R(.button(right), .rst(reset), .clk_4Hz(clk_4Hz), .debounced(wirer_debounced));
    debounce L(.button(left), .rst(reset), .clk_4Hz(clk_4Hz), .debounced(wireL_debounced));
    debounce S(.button(shoot), .rst(reset), .clk_4Hz(clk_4Hz), .debounced(wireshoot_debounced)) ;
    VGA_counter vc(.clk_100MHz(clk_100MHz), .reset(reset), .video_on(wire_video), .hsync(hsync), 
                      .vsync(vsync), .p_tick(wire_ptick), .x(wire_x), .y(wire_y));
    Ship_Gen sg(.left(wireL_debounced), .right(wirer_debounced), .shoot(wireshoot_debounced), .clk(clk_100MHz), .reset(reset), 
                        .video_on(wire_video), .x(wire_x), .y(wire_y), .rgb(rgb_next), .ship_on(wireship_on), .laser_on(wirelaser_on), .laser_T(lasertop) ,
                        .laser_R(laserright), .laser_L(laserleft), .laser_B(laserbot),.ship_shot(ship_shot), .laser_shot(laser_shot) );
    Position_Gen pg(.laser_on(wirelaser_on), .ship_on(wireship_on), .clk(clk_100MHz), .reset(reset), .video_on(wire_video), 
                        .x(wire_x), .y(wire_y), .rgb(rgb_next), .laser_top(lasertop), .laser_left(laserleft), .laser_right(laserright), .laser_bot(laserbot),.ship_shot(ship_shot),
                        .laser_shot(laser_shot) );
                        
    // rgb buffer
    always @(posedge clk_100MHz)
        if(wire_ptick)
            rgb_reg <= rgb_next;
           
    assign rgb = rgb_reg;
   
    
endmodule
