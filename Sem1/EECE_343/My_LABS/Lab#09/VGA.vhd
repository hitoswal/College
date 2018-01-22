------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;
-- Module Generates Video Sync Signals for Video Montor Interface
-- RGB and Sync outputs tie directly to monitor conector pins
ENTITY VGA_SYNC IS
	PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END VGA_SYNC;

ARCHITECTURE a OF VGA_SYNC IS
	SIGNAL horiz_sync, vert_sync,clock_25Mhz : STD_LOGIC;
	SIGNAL video_on_int, video_on_v, video_on_h : STD_LOGIC;
	SIGNAL h_count, v_count :STD_LOGIC_VECTOR(9 DOWNTO 0);
--
-- To select a different screen resolution, clock rate, and refresh rate
-- pick a set of new video timing constant values from table at end of code section
-- enter eight new sync timing constants below and
-- adjust PLL frequency output to pixel clock rate from table
-- using MegaWizard to edit video_PLL.vhd
-- Horizontal Timing Constants  
	CONSTANT H_pixels_across: 	Natural := 640;
	CONSTANT H_sync_low: 		Natural := 664;
	CONSTANT H_sync_high: 		Natural := 760;
	CONSTANT H_end_count: 		Natural := 800;
-- Vertical Timing Constants
	CONSTANT V_pixels_down: 	Natural := 480;
	CONSTANT V_sync_low: 		Natural := 491;
	CONSTANT V_sync_high: 		Natural := 493;
	CONSTANT V_end_count: 		Natural := 525;
--
BEGIN
--
---- PLL below is used to generate the pixel clock frequency
---- Uses UP 3's 48Mhz USB clock for PLL's input clock

-- video_on is high only when RGB pixel data is being displayed
-- used to blank color signals at screen edges during retrace
video_on_int <= video_on_H AND video_on_V;
-- output pixel clock and video on for external user logic

video_on <= video_on_int;

CLOCK_25M : PROCESS(clock_50Mhz)
BEGIN
   IF (clock_50Mhz' EVENT AND clock_50Mhz='1') THEN
		clock_25MHz<= clock_25MHz XOR '1';
   END IF;
END PROCESS CLOCK_25M;
	
pixel_clock<=clock_25Mhz;
	
a1: PROCESS
BEGIN
	
WAIT UNTIL(clock_25Mhz'EVENT) AND (clock_25Mhz='1');
--Generate Horizontal and Vertical Timing Signals for Video Signal
-- H_count counts pixels (#pixels across + extra time for sync signals)
-- 
--  Horiz_sync  ------------------------------------__________--------
--  H_count     0                 #pixels            sync low      end
--
	IF (h_count = H_end_count) THEN
   		h_count <= "0000000000";
	ELSE
   		h_count <= h_count + 1;
	END IF;

--Generate Horizontal Sync Signal using H_count
	IF (h_count <= H_sync_high) AND (h_count >= H_sync_low) THEN
 	  	horiz_sync <= '0';
	ELSE
 	  	horiz_sync <= '1';
	END IF;

--V_count counts rows of pixels (#pixel rows down + extra time for V sync signal)
--  
--  Vert_sync      -----------------------------------------------_______------------
--  V_count         0                        last pixel row      V sync low       end
--
	IF (v_count >= V_end_count) AND (h_count >= H_sync_low) THEN
   		v_count <= "0000000000";
	ELSIF (h_count = H_sync_low) THEN
   		v_count <= v_count + 1;
	END IF;

-- Generate Vertical Sync Signal using V_count
	IF (v_count <= V_sync_high) AND (v_count >= V_sync_low) THEN
   		vert_sync <= '0';
	ELSE
  		vert_sync <= '1';
	END IF;

-- Generate Video on Screen Signals for Pixel Data
-- Video on = 1 indicates pixel are being displayed
-- Video on = 0 retrace - user logic can update pixel
-- memory without needing to read memory for display
	IF (h_count < H_pixels_across) THEN
   		video_on_h <= '1';
   		pixel_column <= h_count;
	ELSE
	   	video_on_h <= '0';
	END IF;

	IF (v_count <= V_pixels_down) THEN
   		video_on_v <= '1';
   		pixel_row <= v_count;
	ELSE
   		video_on_v <= '0';
	END IF;

-- Put all video signals through DFFs to eliminate any small timing delays that cause a blurry image
		horiz_sync_out <= horiz_sync;
		vert_sync_out <= vert_sync;
-- 		Also turn off RGB color signals at edge of screen during vertical and horizontal retrace
		red_out <= red AND video_on_int;
		green_out <= green AND video_on_int;
		blue_out <= blue AND video_on_int;

END PROCESS a1;
END a;
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

PACKAGE vga_sync_package IS
COMPONENT vga_sync
PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END COMPONENT;
END vga_sync_package;


-- Main Program 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 

ENTITY VGA_BALL IS
   PORT(clock_50Mhz	: IN std_logic;
			speed, size : in integer;
        VGA_Red,VGA_Green,VGA_Blue,VGA_HSync,VGA_VSync,video_blank_out,Video_clock_out	:OUT std_logic
        );		
END VGA_BALL;

architecture behavior of VGA_BALL is
COMPONENT vga_sync
PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END COMPONENT;
signal pixel_row_sig, pixel_column_sig: STD_LOGIC_VECTOR(9 DOWNTO 0);

COMPONENT ball
PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
		  speed, size					: integer;
        Vert_sync	: IN std_logic);
END COMPONENT;
signal red_sig,green_sig,blue_sig,vert_sync_sig : STD_LOGIC;

BEGIN    

sync0:vga_sync port map(clock_50Mhz,red_sig,green_sig,blue_sig,VGA_Red,VGA_Green,VGA_Blue,
                        VGA_HSync, vert_sync_sig,video_blank_out,Video_clock_out,pixel_row_sig, 
                        pixel_column_sig);

ball0: ball port map( pixel_row_sig, pixel_column_sig,red_sig,green_sig,blue_sig,speed, size, vert_sync_sig);
      
      VGA_VSync<=vert_sync_sig;


END behavior;


-- Bouncing Ball Video 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
			-- Bouncing Ball Video 


ENTITY ball IS


   PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
		  speed, size					: integer;
        Vert_sync	: IN std_logic);
       
		
		
END ball;

architecture behavior of ball is

			-- Video Display Signals   
SIGNAL Ball_on, Direction, Box1, Box2, Box3	: std_logic;
SIGNAL Size_in, size_x, size_y		: std_logic_vector(9 DOWNTO 0);  
SIGNAL Ball_Y_motion, Ball_X_motion	: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_Y_pos, Ball_X_pos		: std_logic_vector(9 DOWNTO 0);
SIGNAL Box1_Y_pos, Box1_X_pos		: std_logic_vector(9 DOWNTO 0);
SIGNAL Box2_Y_pos, Box2_X_pos		: std_logic_vector(9 DOWNTO 0);
SIGNAL Box3_Y_pos, Box3_X_pos		: std_logic_vector(9 DOWNTO 0);


BEGIN           

Size_in <= CONV_STD_LOGIC_VECTOR(size,10);
size_x <= CONV_STD_LOGIC_VECTOR(213,10);
size_y <= CONV_STD_LOGIC_VECTOR(480,10);
Box1_X_pos <= CONV_STD_LOGIC_VECTOR(0,10);
Box2_X_pos <= CONV_STD_LOGIC_VECTOR(213,10);
Box3_X_pos <= CONV_STD_LOGIC_VECTOR(426,10);
Box1_Y_pos <= CONV_STD_LOGIC_VECTOR(0,10);
Box2_Y_pos <= CONV_STD_LOGIC_VECTOR(0,10);
Box3_Y_pos <= CONV_STD_LOGIC_VECTOR(0,10);


		-- Colors for pixel data on video signal
Red <=  NOT Ball_on xor not Box1;
		-- Turn off Green and Blue when displaying ball
Green <= NOT Ball_on xor not Box2;
Blue <= '1' xor not Box3;

RGB_Display: Process (Ball_X_pos, Ball_Y_pos, pixel_column, pixel_row, Size)
BEGIN
			-- Set Ball_on ='1' to display ball
 IF ('0' & Ball_X_pos <= pixel_column + Size_in) AND
 			-- compare positive numbers only
 	(Ball_X_pos + Size_in >= '0' & pixel_column) AND
 	('0' & Ball_Y_pos <= pixel_row + Size_in) AND
 	(Ball_Y_pos + Size_in >= '0' & pixel_row ) THEN
 		Ball_on <= '1';
 	ELSE
 		Ball_on <= '0';
END IF;

 IF ('0' & Box1_X_pos <= pixel_column + size_x) AND
 			-- compare positive numbers only
 	(Box1_X_pos + size_x >= '0' & pixel_column) AND
 	('0' & Box1_Y_pos <= pixel_row + size_y) AND
 	(Box1_Y_pos + size_y >= '0' & pixel_row ) THEN
 		Box1 <= '1';
 	ELSE
 		Box1 <= '0';
END IF;

 IF ('0' & Box2_X_pos <= pixel_column + size_x) AND
 			-- compare positive numbers only
 	(Box2_X_pos + size_x >= '0' & pixel_column) AND
 	('0' & Box2_Y_pos <= pixel_row + size_y) AND
 	(Box2_Y_pos + size_y >= '0' & pixel_row ) THEN
 		Box2 <= '1';
 	ELSE
 		Box2 <= '0';
END IF;

 IF ('0' & Box3_X_pos <= pixel_column + size_x) AND
 			-- compare positive numbers only
 	(Box3_X_pos + size_x >= '0' & pixel_column) AND
 	('0' & Box3_Y_pos <= pixel_row + size_y) AND
 	(Box3_Y_pos + size_y >= '0' & pixel_row ) THEN
 		Box3 <= '1';
 	ELSE
 		Box3 <= '0';
END IF;
END process RGB_Display;


Move_Ball: process(vert_sync)
BEGIN
			-- Move ball once every vertical sync
	if(vert_sync'event and vert_sync = '1') then
			-- Bounce off top or bottom of screen
			IF ('0' & Ball_Y_pos) >= 480 - Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(-speed,10);
			ELSIF Ball_Y_pos <= Size THEN
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(speed,10);
			END IF;
			IF ('0' & Ball_X_pos) >= 640 - Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(-speed,10);
			ELSIF Ball_X_pos <= Size THEN
				Ball_X_motion <= CONV_STD_LOGIC_VECTOR(speed,10);
			END IF;
			-- Compute next ball Y position
				Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;
				Ball_X_pos <= Ball_X_pos + Ball_X_motion;
	end if;
END process Move_Ball;

END behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
PACKAGE ball_package IS
COMPONENT ball
 PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
        Vert_sync	: IN std_logic);
END COMPONENT;
END ball_package;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
