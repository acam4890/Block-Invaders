`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 09:37:13 AM
// Design Name: 
// Module Name: Position_Gen
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


module Position_Gen(
    input laser_on,
    input ship_on,
    input clk,
    input reset,
    input video_on,
    input [9:0] x,
    input [9:0] y,
    
    
    input [9:0] laser_top,
    input [9:0] laser_left,
    input [9:0] laser_right,
    input [9:0] laser_bot,
    
    
    output reg [11:0] rgb,
    output ship_shot ,
    output laser_shot
    );
//////////////////////////////////////////////////////////////////////   
    wire refresh_tick;
    assign refresh_tick = ((y==481) && (x == 0)) ? 1:0;
//////////////////////////////////////////////////////////////////////   
    parameter x_bound = 639;
    parameter y_bound = 479;
    parameter alien_length = 40;
    parameter alien_velocity_pos = 1;
    parameter alien_velocity_neg = -1;
    parameter alien_height = 20;
//////////////////////////////////////////////////////////////////////        
    wire [9:0] alien1_next;
    wire [9:0] alien2_next;
    wire [9:0] alien3_next;
    wire [9:0] alien4_next;
    wire [9:0] alien5_next;
    wire [9:0] alien6_next; 
    wire [9:0] alien7_next; 
    wire [9:0] alien8_next; 
    wire [9:0] alien9_next; 
    wire [9:0] alien10_next; 
///////////////////////////////////////////////////////////////////////    
    reg [9:0] alien1_xreg;
    reg [9:0] alien2_xreg;
    reg [9:0] alien3_xreg;
    reg [9:0] alien4_xreg;
    reg [9:0] alien5_xreg;
    reg [9:0] alien6_xreg; 
    reg [9:0] alien7_xreg; 
    reg [9:0] alien8_xreg; 
    reg [9:0] alien9_xreg; 
    reg [9:0] alien10_xreg;
////////////////////////////////////////////////////////////////////////
    reg [9:0] alien_xDirection;
    reg [9:0] alien_xDirectionNext;
/////////////////////////////////////////////////////////////////////////   
    reg alien1shot = 0;
    reg alien2shot = 0;
    reg alien3shot = 0;
    reg alien4shot = 0;
    reg alien5shot = 0;
    reg alien6shot = 0;
    reg alien7shot = 0;
    reg alien8shot = 0;
    reg alien9shot = 0;
    reg alien10shot = 0;
    reg ship_shot = 0; 
    reg laser_shot = 0;
//////////////////////////////////////////////////////////////////////////
    wire [9:0] alien1_L;
    wire [9:0] alien1_R;        
    wire [9:0] alien2_L;
    wire [9:0] alien2_R;      
    wire [9:0] alien3_L;
    wire [9:0] alien3_R;    
    wire [9:0] alien4_L;
    wire [9:0] alien4_R;       
    wire [9:0] alien5_L;
    wire [9:0] alien5_R;
    wire [9:0] alien6_L;
    wire [9:0] alien6_R;        
    wire [9:0] alien7_L;
    wire [9:0] alien7_R;      
    wire [9:0] alien8_L;
    wire [9:0] alien8_R;    
    wire [9:0] alien9_L;
    wire [9:0] alien9_R;       
    wire [9:0] alien10_L;
    wire [9:0] alien10_R;
//////////////////////////////////////////////////////////////////////////////    
      // Down movement registers for current position
    reg [9:0] alien_yReg;
    reg [9:0] alien_yRow2Reg;  
///////////////////////////////////////////////////////////////////////////////    
    //Down movement wires for next position
    reg [9:0] alien_yNext;    
    reg [9:0] alien_yRow2Next;
//////////////////////////////////////////////////////////////////////////////    
    // Down movement wires for current position
    wire [9:0] alien_T;
    wire [9:0] alien_B;
    wire [9:0] alien_Trow2;
    wire [9:0] alien_Brow2;
/////////////////////////////////////////////////////////////////////////////
//Initial Conditions for the registers //    
    always@(posedge clk or posedge reset)begin
        if(reset) begin
            alien1_xreg <= 10;
            alien2_xreg <= 60;
            alien3_xreg <= 110;
            alien4_xreg <= 160;
            alien5_xreg <= 210;
            alien6_xreg <= 10;
            alien7_xreg <= 60;
            alien8_xreg <= 110;
            alien9_xreg <= 160;
            alien10_xreg <= 210;
            alien_yReg <= 10;  
            alien_yRow2Reg <= 60;
            
            alien_xDirection <= 10'h002; end
            
        else begin
            alien1_xreg <= alien1_next;
            alien2_xreg <= alien2_next;
            alien3_xreg <= alien3_next;
            alien4_xreg <= alien4_next;
            alien5_xreg <= alien5_next;
            alien6_xreg <= alien6_next;
            alien7_xreg <= alien7_next;
            alien8_xreg <= alien8_next;
            alien9_xreg <= alien9_next;
            alien10_xreg <= alien10_next;
            alien_yReg <= alien_yNext;   
            alien_yRow2Reg <= alien_yRow2Next;
            alien_xDirection <= alien_xDirectionNext; end end
   ///////////////////////////////////////////////////////////////////////////////     
   //Assigning the left and right boudnaries for each of the alien blocks // 
    assign alien1_L = alien1_xreg;
    assign alien1_R = alien1_xreg + alien_length - 1;
    assign alien2_L = alien2_xreg;
    assign alien2_R = alien2_xreg + alien_length - 1;
    assign alien3_L = alien3_xreg; 
    assign alien3_R = alien3_xreg + alien_length - 1;
    assign alien4_L = alien4_xreg; 
    assign alien4_R = alien4_xreg + alien_length - 1;
    assign alien5_L = alien5_xreg; 
    assign alien5_R = alien5_xreg + alien_length - 1;
    assign alien6_L = alien6_xreg;
    assign alien6_R = alien6_xreg + alien_length - 1;
    assign alien7_L = alien7_xreg;
    assign alien7_R = alien7_xreg + alien_length - 1;
    assign alien8_L = alien8_xreg; 
    assign alien8_R = alien8_xreg + alien_length - 1;
    assign alien9_L = alien9_xreg; 
    assign alien9_R = alien9_xreg + alien_length - 1;
    assign alien10_L = alien10_xreg; 
    assign alien10_R = alien10_xreg + alien_length - 1;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Collision Detection// 
    always @(posedge clk or posedge reset ) begin
          if (reset) begin 
                alien1shot = 0;
                alien2shot = 0;
                alien3shot = 0;
                alien4shot = 0;
                alien5shot = 0;
                alien6shot = 0;
                alien7shot = 0;
                alien8shot = 0;
                alien9shot = 0;
                alien10shot= 0;
                ship_shot  = 0;
                laser_shot = 0;end
                
              else if ((laser_bot <= alien_B) && (laser_top >= alien_T)  && (laser_left >= alien1_L) && (laser_right<= alien1_R)) begin 
                     alien1shot = 1;end            
              else if ((laser_bot <= alien_B) && (laser_top >= alien_T)  && (laser_left >= alien2_L) && (laser_right<= alien2_R)) begin 
                     alien2shot = 1; end
              else if ((laser_bot <= alien_B) && (laser_top >= alien_T)  && (laser_left >= alien3_L) && (laser_right<= alien3_R))begin
                     alien3shot = 1; end
              else if ((laser_bot <= alien_B) && (laser_top >= alien_T)  && (laser_left >= alien4_L) && (laser_right<= alien4_R))begin
                     alien4shot = 1; end
              else if ((laser_bot <= alien_B) && (laser_top >= alien_T)  && (laser_left >= alien5_L) && (laser_right<= alien5_R))begin
                     alien5shot = 1; end 
              else if ((laser_bot <= alien_Brow2) && (laser_top >= alien_Trow2)  && (laser_left >= alien6_L) && (laser_right<= alien6_R)) begin 
                     alien6shot = 1;end            
              else if ((laser_bot <= alien_Brow2) && (laser_top >= alien_Trow2)  && (laser_left >= alien7_L) && (laser_right<= alien7_R)) begin 
                     alien7shot = 1; end
              else if ((laser_bot <= alien_Brow2) && (laser_top >= alien_Trow2)  && (laser_left >= alien8_L) && (laser_right<= alien8_R))begin
                     alien8shot = 1; end
              else if ((laser_bot <= alien_Brow2) && (laser_top >= alien_Trow2)  && (laser_left >= alien9_L) && (laser_right<= alien9_R))begin
                     alien9shot = 1; end
              else if ((laser_bot <= alien_Brow2) && (laser_top >= alien_Trow2)  && (laser_left >= alien10_L) && (laser_right<= alien10_R))begin
                     alien10shot = 1; end 
              else if ( alien_Brow2 == 459) begin 
                        ship_shot = 1 ;
                        laser_shot = 1; end
              
    end
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Assigning values into top and bottom for both row's of bliocks//
    assign alien_T = alien_yReg;
    assign alien_B = alien_yReg + alien_height - 1;
    assign alien_Trow2 = alien_yRow2Reg;
    assign alien_Brow2 = alien_yRow2Reg + alien_height - 1;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Creating conditions to turn on each alien block//
    assign Alien1_on = ((alien_T<=y) && (alien_B>=y) && (alien1_L<=x) && (alien1_R>=x)  && (!alien1shot)) ? 1:0;
    assign Alien2_on = ((alien_T<=y) && (alien_B>=y) && (alien2_L<=x) && (alien2_R>=x)  && (!alien2shot)) ? 1:0;
    assign Alien3_on = ((alien_T<=y) && (alien_B>=y) && (alien3_L<=x) && (alien3_R>=x)  && (!alien3shot)) ? 1:0;
    assign Alien4_on = ((alien_T<=y) && (alien_B>=y) && (alien4_L<=x) && (alien4_R>=x)  && (!alien4shot)) ? 1:0;
    assign Alien5_on = ((alien_T<=y) && (alien_B>=y) && (alien5_L<=x) && (alien5_R>=x)  && (!alien5shot)) ? 1:0;
    assign Alien6_on = ((alien_Trow2<=y) && (alien_Brow2>=y) && (alien6_L<=x) && (alien6_R>=x)&& (!alien6shot)) ? 1:0;
    assign Alien7_on = ((alien_Trow2<=y) && (alien_Brow2>=y) && (alien7_L<=x) && (alien7_R>=x)&& (!alien7shot)) ? 1:0;
    assign Alien8_on = ((alien_Trow2<=y) && (alien_Brow2>=y) && (alien8_L<=x) && (alien8_R>=x)&& (!alien8shot)) ? 1:0;
    assign Alien9_on = ((alien_Trow2<=y) && (alien_Brow2>=y) && (alien9_L<=x) && (alien9_R>=x)&& (!alien9shot)) ? 1:0;
    assign Alien10_on =((alien_Trow2<=y) && (alien_Brow2>=y) && (alien10_L<=x) && (alien10_R>=x)&& (!alien10shot)) ? 1:0;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign alien1_next = (refresh_tick) ? alien1_xreg + alien_xDirection : alien1_xreg;
    assign alien2_next = (refresh_tick) ? alien2_xreg + alien_xDirection : alien2_xreg;
    assign alien3_next = (refresh_tick) ? alien3_xreg + alien_xDirection : alien3_xreg;
    assign alien4_next = (refresh_tick) ? alien4_xreg + alien_xDirection : alien4_xreg;
    assign alien5_next = (refresh_tick) ? alien5_xreg + alien_xDirection : alien5_xreg;
    assign alien6_next = (refresh_tick) ? alien6_xreg + alien_xDirection : alien6_xreg;
    assign alien7_next = (refresh_tick) ? alien7_xreg + alien_xDirection : alien7_xreg;
    assign alien8_next = (refresh_tick) ? alien8_xreg + alien_xDirection : alien8_xreg;
    assign alien9_next = (refresh_tick) ? alien9_xreg + alien_xDirection : alien9_xreg;
    assign alien10_next = (refresh_tick) ? alien10_xreg + alien_xDirection : alien10_xreg;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Alien left and right boundaries //
    always @* begin
        alien_xDirectionNext = alien_xDirection;
        if (alien1_L < 1) //alien one is the alien farthest to left so it hits the left border first
            alien_xDirectionNext = alien_velocity_pos;
        else if(alien5_R > x_bound) //alien five hits the right border first
            alien_xDirectionNext = alien_velocity_neg;
    end
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //alien moving down//
    always @* begin
        alien_yNext = alien_yReg;
        alien_yRow2Next = alien_yRow2Reg;
        if(refresh_tick) begin
            if(alien_B < 479) begin //Stops when top row reaches bottom or when kills ship when collision added.
                if(alien5_R > x_bound) begin //Aliens moves down when right boundry is hit
                    alien_yNext = alien_yReg + 10;
                    alien_yRow2Next = alien_yRow2Reg + 10;end
                else begin
                    alien_yNext = alien_yReg; //otherwise alien stays in position if right boundry isn't hit
                    alien_yRow2Next = alien_yRow2Reg;end end
            else begin
                alien_yNext = alien_yReg; //alien stays in position if bottom of screen is reached by top row
                alien_yRow2Next = alien_yRow2Reg;end end
        end
    /////////////////////////////////////////////////////////////////////////////////////////
    //Multiplexer for aliens, block, and laser //
    always @(posedge clk) begin
        if(~video_on)
            rgb = 12'h000;
        else if(Alien1_on)     
            rgb = 12'hFFF;                    
        else if(Alien2_on)         
            rgb = 12'hFFF;                         
        else if(Alien3_on)         
            rgb = 12'hFFF;                       
        else if(Alien4_on)         
            rgb = 12'hFFF;                      
        else if(Alien5_on)         
            rgb = 12'hFFF;
        else if(Alien6_on)     
            rgb = 12'hFFF;                    
        else if(Alien7_on)         
            rgb = 12'hFFF;                         
        else if(Alien8_on)         
            rgb = 12'hFFF;                       
        else if(Alien9_on)         
            rgb = 12'hFFF;                      
        else if(Alien10_on)         
            rgb = 12'hFFF;
        else if(ship_on)       
            rgb = 12'hFFF;
        else if(laser_on)
            rgb = 12'hFFF;       
        else
            rgb = 12'h000; end
endmodule
