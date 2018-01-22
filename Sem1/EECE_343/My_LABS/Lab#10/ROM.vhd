library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;

entity char_rom is
	port(	clock							: in std_logic;
			character_address			: in	std_logic_vector(7 downto 0);
			font_row, font_col			: in 	std_logic_vector(2 downto 0);
			rom_mux_output	: out	std_logic);
end char_rom;

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
