LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 

ENTITY MIF_Test IS
   PORT(clock_50Mhz	: IN std_logic;
        VGA_Red,VGA_Green,VGA_Blue,VGA_HSync,VGA_VSync,video_blank_out,Video_clock_out	:OUT std_logic
        );		
END MIF_Test;

architecture behavior of MIF_Test is
COMPONENT vga_sync
PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END COMPONENT;
signal pixel_row_sig, pixel_column_sig: STD_LOGIC_VECTOR(9 DOWNTO 0);
signal pixel_row_sig_i, pixel_column_sig_i: integer range 0 to 800;

COMPONENT ball
PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
        Vert_sync	, data: IN std_logic);
END COMPONENT;

component char_rom is
	port(	clock							: in std_logic;
			character_address			: in	std_logic_vector(5 downto 0);
			font_row, font_col			: in 	std_logic_vector(2 downto 0);
			rom_mux_output	: out	std_logic);
end component;

signal red_sig,green_sig,blue_sig,vert_sync_sig ,data : STD_LOGIC;

BEGIN    

sync0:vga_sync port map(clock_50Mhz,red_sig,green_sig,blue_sig,VGA_Red,VGA_Green,VGA_Blue,
                        VGA_HSync, vert_sync_sig,video_blank_out,Video_clock_out,pixel_row_sig, 
                        pixel_column_sig);
char: char_rom port map (clock_50Mhz, "000000", pixel_row_sig(4 downto 2), pixel_column_sig(4 downto 2), data);		

pixel_row_sig_i <= conv_integer(pixel_row_sig);
pixel_column_sig_i <= conv_integer(pixel_column_sig);
process(pixel_row_sig_i,pixel_column_sig_i)
begin
if(((pixel_row_sig_i >= 252) and (pixel_column_sig_i >= 223))and(pixel_row_sig_i <= 286) and (pixel_column_sig_i <= 255)) then
red_sig		<=	not data;
green_sig	<=	not data;
blue_sig		<= '1';
else
red_sig		<=	'1';
green_sig	<=	'1';
blue_sig		<= '1';
end if;
end process;
 VGA_VSync<=vert_sync_sig;		
END behavior;

