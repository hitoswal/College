------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;
-- module generates video sync signals for video montor interface
-- rgb and sync outputs tie directly to monitor conector pins
entity vga_sync is
	port(	clock_50mhz, red, green, blue		: in	std_logic;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: out	std_logic;
			pixel_row, pixel_column: out std_logic_vector(9 downto 0));
end vga_sync;

architecture a of vga_sync is
	signal horiz_sync, vert_sync,clock_25mhz : std_logic;
	signal video_on_int, video_on_v, video_on_h : std_logic;
	signal h_count, v_count :std_logic_vector(9 downto 0);
--
-- to select a different screen resolution, clock rate, and refresh rate
-- pick a set of new video timing constant values from table at end of code section
-- enter eight new sync timing constants below and
-- adjust pll frequency output to pixel clock rate from table
-- using megawizard to edit video_pll.vhd
-- horizontal timing constants  
	constant h_pixels_across: 	natural := 640;
	constant h_sync_low: 		natural := 664;
	constant h_sync_high: 		natural := 760;
	constant h_end_count: 		natural := 800;
-- vertical timing constants
	constant v_pixels_down: 	natural := 480;
	constant v_sync_low: 		natural := 491;
	constant v_sync_high: 		natural := 493;
	constant v_end_count: 		natural := 525;
--
begin
--
---- pll below is used to generate the pixel clock frequency
---- uses up 3's 48mhz usb clock for pll's input clock

-- video_on is high only when rgb pixel data is being displayed
-- used to blank color signals at screen edges during retrace
video_on_int <= video_on_h and video_on_v;
-- output pixel clock and video on for external user logic

video_on <= video_on_int;

clock_25m : process(clock_50mhz)
begin
   if (clock_50mhz' event and clock_50mhz='1') then
		clock_25mhz<= clock_25mhz xor '1';
   end if;
end process clock_25m;
	
pixel_clock<=clock_25mhz;
	
a1: process
begin
	
wait until(clock_25mhz'event) and (clock_25mhz='1');
--generate horizontal and vertical timing signals for video signal
-- h_count counts pixels (#pixels across + extra time for sync signals)
-- 
--  horiz_sync  ------------------------------------__________--------
--  h_count     0                 #pixels            sync low      end
--
	if (h_count = h_end_count) then
   		h_count <= "0000000000";
	else
   		h_count <= h_count + 1;
	end if;

--generate horizontal sync signal using h_count
	if (h_count <= h_sync_high) and (h_count >= h_sync_low) then
 	  	horiz_sync <= '0';
	else
 	  	horiz_sync <= '1';
	end if;

--v_count counts rows of pixels (#pixel rows down + extra time for v sync signal)
--  
--  vert_sync      -----------------------------------------------_______------------
--  v_count         0                        last pixel row      v sync low       end
--
	if (v_count >= v_end_count) and (h_count >= h_sync_low) then
   		v_count <= "0000000000";
	elsif (h_count = h_sync_low) then
   		v_count <= v_count + 1;
	end if;

-- generate vertical sync signal using v_count
	if (v_count <= v_sync_high) and (v_count >= v_sync_low) then
   		vert_sync <= '0';
	else
  		vert_sync <= '1';
	end if;

-- generate video on screen signals for pixel data
-- video on = 1 indicates pixel are being displayed
-- video on = 0 retrace - user logic can update pixel
-- memory without needing to read memory for display
	if (h_count < h_pixels_across) then
   		video_on_h <= '1';
   		pixel_column <= h_count;
	else
	   	video_on_h <= '0';
	end if;

	if (v_count <= v_pixels_down) then
   		video_on_v <= '1';
   		pixel_row <= v_count;
	else
   		video_on_v <= '0';
	end if;

-- put all video signals through dffs to eliminate any small timing delays that cause a blurry image
		horiz_sync_out <= horiz_sync;
		vert_sync_out <= vert_sync;
-- 		also turn off rgb color signals at edge of screen during vertical and horizontal retrace
		red_out <= red and video_on_int;
		green_out <= green and video_on_int;
		blue_out <= blue and video_on_int;

end process a1;
end a;
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package vga_sync_package is
component vga_sync
port(	clock_50mhz, red, green, blue		: in	std_logic;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: out	std_logic;
			pixel_row, pixel_column: out std_logic_vector(9 downto 0));
end component;
end vga_sync_package;
------------------------------------------------------------------------------
------------------------------------------------------------------------------