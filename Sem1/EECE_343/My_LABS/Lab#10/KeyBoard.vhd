------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------LAB10-------------------------------------
-------------------------------------BY---------------------------------------
------------------------------Hitesh Vijay Oswal------------------------------
-------------------------------------AND--------------------------------------
---------------------------------Omkar Sali-----------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity KeyBoard is
port(	clk, keyboard_clk, keyboard_data, reset	:in std_logic;
		seg0, seg1	: out std_logic_vector(6 downto 0);
		VGA_Red,VGA_Green,VGA_Blue,VGA_HSync,VGA_VSync,video_blank_out,Video_clock_out	:OUT std_logic);
end KeyBoard;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
architecture ckt of keyBoard is
------------------------------------------------------------------------------
component slowclk is
port(clk: in std_logic;
		clkout: out std_logic);
end component;
------------------------------------------------------------------------------
component keyboard_KEY is
port( keyboard_clk, keyboard_data, clock_25mhz ,reset, read	:in std_logic;
		scan_code	:	out std_logic_vector(7 downto 0);
		scan_ready 	: out std_logic);
end component;
------------------------------------------------------------------------------
component SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end component; 
------------------------------------------------------------------------------
COMPONENT vga_sync
PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END COMPONENT;
------------------------------------------------------------------------------
component char_rom is
	port(	clock							: in std_logic;
			character_address			: in	std_logic_vector(7 downto 0);
			font_row, font_col			: in 	std_logic_vector(2 downto 0);
			rom_mux_output	: out	std_logic);
end component;
------------------------------------------------------------------------------
signal red_sig, green_sig, blue_sig, vert_sync_sig  : STD_LOGIC; 
signal Char_Data, SCL_Data, SCM_Data : STD_LOGIC;
signal pixel_row_sig, pixel_column_sig: STD_LOGIC_VECTOR(9 DOWNTO 0);
signal X_Pos, Y_Pos: integer range 0 to 800;
signal X_Char, Y_Char: integer range 0 to 800;
signal X_SCL, Y_SCL: integer range 0 to 800;
signal X_SCM, Y_SCM: integer range 0 to 800;
signal Scan_Code	:	std_logic_vector (7 downto 0);
signal clk_25 		: std_logic;
signal scan_ready	: std_logic;
signal SCL, SCM	: integer range 0 to 15;
signal SCL_ADD, SCM_ADD : std_logic_vector(7 downto 0);
------------------------------------------------------------------------------
begin
slwclk: slowclk port map (clk, clk_25);

key: keyboard_KEY port map (keyboard_clk => keyboard_clk, keyboard_data => keyboard_data, clock_25mhz=>clk_25, reset => '0', read =>'0', scan_code => Scan_Code, scan_ready => scan_ready);

S0: SevSegDisp port map (Scan_Code(3 downto 0), Seg0);
S1: SevSegDisp port map (Scan_Code(7 downto 4), Seg1);

sync0:vga_sync port map(clk,red_sig,green_sig,blue_sig,VGA_Red,VGA_Green,VGA_Blue,
                        VGA_HSync, vert_sync_sig,video_blank_out,Video_clock_out,pixel_row_sig, 
                        pixel_column_sig);
char1: char_rom port map (clk, Scan_Code, pixel_row_sig(4 downto 2), pixel_column_sig(4 downto 2), Char_Data);		
char2: char_rom port map (clk, SCM_ADD, pixel_row_sig(4 downto 2), pixel_column_sig(4 downto 2), SCM_Data);	
char3: char_rom port map (clk, SCL_ADD, pixel_row_sig(4 downto 2), pixel_column_sig(4 downto 2), SCL_Data);	

X_Pos <= conv_integer(pixel_column_sig(9 downto 5));
Y_Pos <= conv_integer(pixel_row_sig(9 downto 5));

X_SCL <= 15;
X_SCM <= 13;
X_Char <= 5;

Y_SCL <= 7;
Y_SCM <= 7;
Y_Char <= 7;

process(X_Pos, Y_Pos)
begin
if(X_Pos = X_Char and Y_Pos = Y_Char) then
red_sig		<=	not Char_Data;
green_sig	<=	not Char_Data;
blue_sig		<= '1';
elsif (X_Pos = X_SCM and Y_Pos = Y_SCM) then
red_sig		<= not SCM_Data;
green_sig	<=	'1';
blue_sig		<= '1';
elsif (X_Pos = X_SCL and Y_Pos = Y_SCL) then
red_sig		<=	not SCL_Data;
green_sig	<=	'1';
blue_sig		<= '1';
else
red_sig		<=	'1';
green_sig	<=	'1';
blue_sig		<= '1';
end if;
end process;

SCL <= conv_integer(Scan_Code(3 downto 0));
SCM <= conv_integer(Scan_Code(7 downto 4));

process(SCL, SCM)
begin

case SCL is

When 0 =>
SCL_ADD <= "01000101";
When 1 =>
SCL_ADD <= "00010110";
When 2 =>
SCL_ADD <= "00011110";
When 3 =>
SCL_ADD <= "00100110";
When 4 =>
SCL_ADD <= "00100101";
When 5 =>
SCL_ADD <= "00101110";
When 6 =>
SCL_ADD <= "00110110";
When 7 =>
SCL_ADD <= "00111101";
When 8 =>
SCL_ADD <= "00111110";
When 9 =>
SCL_ADD <= "01000110";
When 10 =>
SCL_ADD <= "00011100";
When 11 =>
SCL_ADD <= "00110010";
When 12 =>
SCL_ADD <= "00100001";
When 13 =>
SCL_ADD <= "00100011";
When 14 =>
SCL_ADD <= "00100100";
When 15 =>
SCL_ADD <= "00101011";
end case;

case SCM is

When 0 =>
SCM_ADD <= "01000101";
When 1 =>
SCM_ADD <= "00010110";
When 2 =>
SCM_ADD <= "00011110";
When 3 =>
SCM_ADD <= "00100110";
When 4 =>
SCM_ADD <= "00100101";
When 5 =>
SCM_ADD <= "00101110";
When 6 =>
SCM_ADD <= "00110110";
When 7 =>
SCM_ADD <= "00111101";
When 8 =>
SCM_ADD <= "00111110";
When 9 =>
SCM_ADD <= "01000110";
When 10 =>
SCM_ADD <= "00011100";
When 11 =>
SCM_ADD <= "00110010";
When 12 =>
SCM_ADD <= "00100001";
When 13 =>
SCM_ADD <= "00100011";
When 14 =>
SCM_ADD <= "00100100";
When 15 =>
SCM_ADD <= "00101011";
end case;
end process;

 VGA_VSync<=vert_sync_sig;	

end ckt;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;
-- module generates video sync signals for video montor interface
-- rgb and sync outputs tie directly to monitor conector pins
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity vga_sync is
	port(	clock_50mhz, red, green, blue		: in	std_logic;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: out	std_logic;
			pixel_row, pixel_column: out std_logic_vector(9 downto 0));
end vga_sync;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
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
------------------------------------------------------------------------------
------------------------------------------------------------------------------
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
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity char_rom is
	port(	clock							: in std_logic;
			character_address			: in	std_logic_vector(7 downto 0);
			font_row, font_col			: in 	std_logic_vector(2 downto 0);
			rom_mux_output	: out	std_logic);
end char_rom;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
architecture a of char_rom is
	signal	rom_data: std_logic_vector(7 downto 0);
	signal	rom_address: std_logic_vector(11 downto 0);
begin
-- small 8 by 8 character generator rom for video display
-- each character is 8 8-bits words of pixel data
 char_gen_rom: lpm_rom
      generic map ( lpm_widthad => 12,
        lpm_numwords => 4096,
        lpm_outdata => "unregistered",
        lpm_address_control => "registered",
-- reads in mif file for character generator font data 
         lpm_file => "my.mif",
         lpm_width => 8)
      port map (inclock=> clock, address => rom_address, q => rom_data);

rom_address <= character_address & '0' & font_row;
-- mux to pick off correct rom data bit from 8-bit word
-- for on screen character generation
rom_mux_output <= rom_data ( (conv_integer(not font_col(2 downto 0))));

end a;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity keyboard_KEY is
port( keyboard_clk, keyboard_data, clock_25mhz ,reset, read	:in std_logic;
		scan_code	:	out std_logic_vector(7 downto 0);
		scan_ready 	: out std_logic);
end keyboard_KEY;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
architecture a of keyboard_KEY is 
signal incnt 				:std_logic_vector(3 downto 0);
signal shiftin 			:std_logic_vector(8 downto 0);
signal read_char			:std_logic;
signal inflag, ready_set: std_logic;
signal keyboard_clk_filtered :std_logic;
signal filter	:std_logic_vector(7 downto 0);

begin
process (read, ready_set)
begin

if read = '1' then 
	scan_ready <= '0';
elsif ready_set'event and ready_set = '1' then 
	scan_ready <='1';	
end if;
end process;
--this process filters the raw clock signal coming from the 
-- keyboard using a shift register and two and gates

clock_filter:process
begin
wait until clock_25mhz'event and clock_25mhz = '1'; 
filter (6 downto 0 ) <= filter( 7 downto 1 );
filter( 7 ) <= keyboard_clk;
if filter = "11111111" then 
	keyboard_clk_filtered <= '1';
elsif filter = "00000000" then 
	keyboard_clk_filtered <= '0';
end if;
end process clock_filter;

--this process reads in serial scan code data coming from the keyboard

process
begin
wait until (keyboard_clk_filtered'event and keyboard_clk_filtered = '1'); 
if reset = '1' then
	incnt <="0000";
	read_char <='0';
else
	if keyboard_data = '0' and read_char = '0' then 
	read_char <='1'; 
	ready_set <= '0';
	else
	-- shift in next 8 data bits to assemble a scan code 
		if read_char = '1' then 
			if incnt <"1001" then 
				incnt <= incnt +1;
			shiftin( 7 downto 0 ) <= shiftin( 8 downto 1 ); 
			shiftin( 8 )	<= keyboard_data;
			ready_set <= '0';
			else
			--end of scan code character, so set flags and exit loop
			scan_code <= shiftin( 7 downto 0 );
			read_char <='0';
			ready_set <='1';
			incnt <= "0000";
			end if;
		end if;
	end if;
end if;
end process;
end a;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
entity slowclk is
port(clk: in std_logic;
		clkout: out std_logic);
end slowclk;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
architecture ckt of slowclk is

begin
	process(clk)
	variable cnt: integer range 0 to 2;
	begin
		if (clk'event and clk ='1') then
			if cnt = 2 then
				cnt := 0;
				clkout <= '1';
			else
				cnt := cnt + 1;
				clkout <= '0';
			end if;
		end if;
	end process;
end ckt;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
entity SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end SevSegDisp;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
architecture ckt of sevSegDisp is
signal seg_Data : std_logic_vector(6 downto 0);
begin
process(DataIn)
begin
case DataIn is
	when "0000" => seg_Data <= "1111110"; --0
	when "0001" => seg_Data <= "0110000"; --1
	when "0010" => seg_Data <= "1101101"; --2
	when "0011" => seg_Data <= "1111001"; --3
	when "0100" => seg_Data <= "0110011"; --4
	when "0101" => seg_Data <= "1011011"; --5
	when "0110" => seg_Data <= "1011111"; --6
	when "0111" => seg_Data <= "1110000"; --7
	when "1000" => seg_Data <= "1111111"; --8
	when "1001" => seg_Data <= "1111011"; --9
	when "1010" => seg_Data <= "1110111"; --A
	when "1011" => seg_Data <= "1111111"; --B
	when "1100" => seg_Data <= "1001110"; --C
	when "1101" => seg_Data <= "1111110"; --D
	when "1110" => seg_Data <= "1001111"; --E
	when others => seg_Data <= "1000111"; --F
end case;

Segout(0) <= not seg_Data(6);
Segout(1) <= not seg_Data(5);
Segout(2) <= not seg_Data(4);
Segout(3) <= not seg_Data(3);
Segout(4) <= not seg_Data(2);
Segout(5) <= not seg_Data(1);
Segout(6) <= not seg_Data(0);

end process;
end ckt;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------