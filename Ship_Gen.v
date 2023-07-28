`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: lol I wish
// Engineer: 
// 
// Create Date: 05/04/2023 02:26:47 PM
// Design Name: 
// Module Name: Ship_Gen
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



module Ship_Gen(
    input left, right, shoot,
    input clk,
    input reset,
    input video_on,
    input [9:0] x,
    input [9:0] y,
    input ship_shot,
    input laser_shot,
    
    output reg [11:0] rgb,
    output ship_on,
    output laser_on,
    output [9:0]laser_T ,
    output [9:0]laser_R,
    output [9:0]laser_L,
    output [9:0]laser_B
    );
//////////////////////////////////////////////////////////////////////////////////////////////////
// 60HZ Refresh Tick //    
    wire refresh_tick;                                 
    assign refresh_tick = ((y==481) && (x == 0)) ? 1:0;
//////////////////////////////////////////////////////////////////////////////////////////////////
//Parameter List  //
    parameter y_bound = 479;
    parameter x_bound = 639;
    
    parameter ship_length = 40;
    parameter ship_velocity = 2;
    parameter ship_T = 459;
    parameter ship_B = 479;
    
    parameter laser_velocity = 3;
    parameter laser_offset = 18; //to match center of laser to center of ship
    parameter laser_height = 8;
    parameter laser_width = 4;
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Register List //    
    
    reg[9:0] laser_Xreg, laser_Yreg;
    reg [9:0] laser_Xnext, laser_Ynext;
    reg shot;
    reg [9:0]ship_xreg ;
    reg [9:0]ship_next;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Wire List //
    wire [11:0] ship_rgb;
    wire [9:0] ship_L , ship_R ;
    wire [9:0] laser_T, laser_B;
    wire [9:0] laser_L, laser_R;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
//variable to keep track if the laser has been shot (1) or if it is ready to be shot (0)
    initial shot = 0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
//checking if the laser has been shot yet. this way u can't shoot again until the laser made it to the end of the screen
    always@* begin
        if(shoot && (shot != 1)) begin
            shot = 1; end
        else if(laser_T <= 1) begin
            shot = 0; end
        end
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  //ship movement, laser X movement, and laser Y movement
    always@* begin
        ship_next = ship_xreg;
        laser_Xnext = laser_Xreg;
        laser_Ynext = laser_Yreg;
        if (refresh_tick) begin
            if(shot == 1) begin
                laser_Ynext = laser_Yreg - laser_velocity; end //laser moves up after being shot until it reaches end of screen
            else
                laser_Ynext = 455; //if laser has not been shot then it stays "attached" to ship
                laser_Xnext = ship_xreg + laser_offset; //reset laser to middle of ship after having been shot and reaching end of screen
            if(right && (ship_R < (x_bound-1-ship_velocity))) begin
                ship_next = ship_xreg + ship_velocity; //standard ship movement to right
                if(shot == 0) begin
                    laser_Xnext = laser_Xreg + ship_velocity; end // if laser is not shot then it moves with ship to the right
                else begin
                    laser_Xnext = laser_Xreg; end end
            else if(left && (ship_L > ship_velocity)) begin
                    ship_next = ship_xreg - ship_velocity; //standard ship movement to left
                    if(shot == 0) begin
                        laser_Xnext = laser_Xreg - ship_velocity; end // if laser is not shot then it moves with ship to the right
                    else begin
                        laser_Xnext = laser_Xreg; end end
        end
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Registers loaded with the next postition of laser and ship //      
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            ship_xreg <= 0; //reset ship position
            laser_Yreg <= 455; //reset laser position to "attached" above the ship
            laser_Xreg <= laser_offset;end //reset laser position to middle of ship
        else begin
            ship_xreg <= ship_next;
            laser_Yreg <= laser_Ynext;
            laser_Xreg <= laser_Xnext;end
        end
//////////////////////////////////////////////////////////////////////////////////////////////
// Assigning the left and right boundaries to ship and all boundaries for laser //
    assign ship_L = ship_xreg;
    assign ship_R = ship_xreg + ship_length - 1;
    
    assign laser_T = laser_Yreg;
    assign laser_B = laser_Yreg + laser_height;
    assign laser_L = laser_Xreg;
    assign laser_R = laser_Xreg + laser_width;
///////////////////////////////////////////////////////////////////////////////////////////////
    //ship_on value goes to position_gen cuz that has the rgb multiplexer  
    assign ship_on = (ship_L <= x) && (ship_R >= x) &&
                     (ship_T <= y) && (ship_B >= y)&&(!ship_shot);
    
    //laser_on value goes to position_gen cuz that has the rgb multiplexer                 
    assign laser_on = (laser_L <= x) && (laser_R >= x) &&
                     (laser_T <= y) && (laser_B >= y) && (!laser_shot);
    
endmodule
