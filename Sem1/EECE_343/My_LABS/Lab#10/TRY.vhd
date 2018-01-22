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

process(pixel_column_sig, pixel_row_sig)
begin
if(pixel_column_sig(9 downto 5) = "00100" and pixel_row_sig(9 downto 5) = "00110") then
red_sig		<=	not Char_Data;
green_sig	<=	not Char_Data;
blue_sig		<= '1';
elsif (pixel_column_sig(9 downto 5) = "00110" and pixel_row_sig(9 downto 5) = "00110") then
red_sig		<= not SCM_Data;
green_sig	<=	'1';
blue_sig		<= '1';
elsif (pixel_column_sig(9 downto 5) = "00111" and pixel_row_sig(9 downto 5) = "00110") then
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