-----------------------------------LAB#05-------------------------------------
--------------------------Counter with LCD Display----------------------------
-------------------------------------By---------------------------------------
-----------------------------Hitesh Vijay Oswal-------------------------------
------------------------------------and---------------------------------------
---------------------------------Omkar Sali-----------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity LAB5 is
GENERIC(Num_Hex_Digits: Integer:= 2);
port(	rst, clk, enable, load : in std_logic;
		sw							  : in std_logic_vector(2 downto 0);
		input						  : in std_logic_vector(7 downto 0);
		inc						  : in std_logic_vector (3 downto 0);
		ledout					  : out std_logic_vector(7 downto 0);
		enout, loadled			  : out std_logic;
		swout						  : out std_logic_vector(2 downto 0);
		incout					  : out std_logic_vector (3 downto 0);
		Seg0,Seg1 				  : out std_logic_vector (6 downto 0);
		LCD_RS, LCD_E          : OUT STD_LOGIC;
      LCD_RW                 : OUT   STD_LOGIC;
      LCD_ON                 : OUT STD_LOGIC;
      LCD_BLON               : OUT STD_LOGIC;
      DATA_BUS               : INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
end LAB5;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
architecture ckt of LAB5 is
signal clkout: std_logic;
signal Seg0_Data, Seg1_Data: std_logic_vector (6 downto 0);
signal cnt: std_logic_vector(7 downto 0);
------------------------------------------------------------------------------
component slowclk is
port(clk: in std_logic;
		clkout: out std_logic);
end component;

component SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end component;

component LCD_Display IS
PORT(reset, CLOCK_50       : IN  STD_LOGIC;
       Hex_Display_Data       : IN    STD_LOGIC_VECTOR((Num_Hex_Digits*4)-1 DOWNTO 0);
       HEX_Display_Load			: IN    STD_LOGIC_VECTOR((Num_Hex_Digits*4)-1 DOWNTO 0);
		 HEX_DISPLAY_Inc_Dec		: IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LCD_RS, LCD_E          : OUT STD_LOGIC;
       LCD_RW                 : OUT   STD_LOGIC;
       LCD_ON                 : OUT STD_LOGIC;
       LCD_BLON               : OUT STD_LOGIC;
       DATA_BUS               : INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
END component;
------------------------------------------------------------------------------
begin

stage1: slowclk port map (clk, clkout);

ledout <= input;
enout <= enable;
swout <= sw;
incout <= inc;
loadled <= load;

process(clkout, enable, rst)
begin
		if rst = '0' then
			if sw(1) = '1' then
				cnt <= input;
			elsif sw(0) = '1' and sw(1) = '0' then
				cnt <= "11111111";
			else
				cnt <= "00000000";
			end if;
		else
			if (clkout'event and clkout = '1') then
				if enable = '1' then
					if sw = "000" or sw = "010" then
						cnt <= cnt + 1;
					elsif sw = "001" or sw = "011" then
						cnt <= cnt - 1;
					elsif sw = "100" then
						if cnt > "11111111" - inc then
							cnt <= "00000000";
						else
							cnt <= cnt + inc;
						end if;
					elsif sw = "101" then
						if cnt < "00000000" + inc then
							cnt <= "11111111";
						else
							cnt <= cnt - inc;
						end if;
					elsif sw = "110" then
						if cnt < input - inc then
							cnt <= input;
						else
							cnt <= cnt + inc;
						end if;
					else
						if cnt > input + inc then
							cnt <= input;
						else
							cnt <= cnt - inc;
						end if;
					end if;
				else
					if sw < "010" and cnt = "11111111" then
							cnt <= "00000000";
						end if;
					if load = '1' then
						if sw >= "010" then 
							cnt <= input;
						end if;
					end if;
				end if;
			end if;
		end if;
end process;

Disp1: SevSegDisp port map (cnt(3 downto 0), seg1);
Disp2: SevSegDisp port map (cnt(7 downto 4), seg0);
LCDDisp: LCD_Display port map	(rst, clk, cnt, input, inc, LCD_RS, LCD_E, LCD_RW, LCD_ON, LCD_BLON, DATA_BUS);
end ckt;
------------------------------------------------------------------------------
------------------------------------------------------------------------------