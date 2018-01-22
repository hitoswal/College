-----------------------------------LAB#04-------------------------------------
----------------------------------Counter-------------------------------------
-------------------------------------By---------------------------------------
-----------------------------Hitesh Vijay Oswal-------------------------------
------------------------------------and---------------------------------------
---------------------------------Omkar Sali-----------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity LAB4 is
port(	rst, clk, enable, load: in std_logic;
		sw: in std_logic_vector(2 downto 0);
		input: in std_logic_vector(7 downto 0);
		inc: in std_logic_vector (3 downto 0);
		ledout: out std_logic_vector(7 downto 0);
		enout, loadled: out std_logic;
		swout: out std_logic_vector(2 downto 0);
		incout: out std_logic_vector (3 downto 0);
		Seg0,Seg1 : out std_logic_vector (6 downto 0));
end LAB4;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
architecture ckt of LAB4 is
signal clkout: std_logic;
signal Seg0_Data, Seg1_Data: std_logic_vector (6 downto 0);
------------------------------------------------------------------------------
component slowclk is
port(clk: in std_logic;
		clkout: out std_logic);
end component;
------------------------------------------------------------------------------
begin
stage1: slowclk port map (clk, clkout);

ledout <= input;
enout <= enable;
swout <= sw;
incout <= inc;
loadled <= load;

process(clkout, enable, rst)
variable cnt: std_logic_vector(7 downto 0);
variable Seg0_Cnt, Seg1_Cnt: std_logic_vector (3 downto 0);

begin
		if rst = '0' then
			if sw = "011" or sw = "111" then
				cnt := input;
			elsif sw = "001" or sw = "101" then
				cnt := "11111111";
			else
				cnt := "00000000";
			end if;
		else
			if (clkout'event and clkout = '1') then
				if enable = '1' then
					if sw = "000" or sw = "010" then
						cnt := cnt + 1;
					elsif sw = "001" or sw = "011" then
						cnt := cnt - 1;
					elsif sw = "100" then
						if cnt > "11111111" - inc then
							cnt := "00000000";
						else
							cnt := cnt + inc;
						end if;
					elsif sw = "101" then
						if cnt < "00000000" + inc then
							cnt := "11111111";
						else
							cnt := cnt - inc;
						end if;
					elsif sw = "110" then
						if cnt < input - inc then
							cnt := input;
						else
							cnt := cnt + inc;
						end if;
					else
						if cnt > input + inc then
							cnt := input;
						else
							cnt := cnt - inc;
						end if;
					end if;
				else
					if sw < "010" and cnt = "11111111" then
							cnt := "00000000";
						end if;
					if load = '1' then
						if sw >= "010" then 
							cnt := input;
						end if;
					end if;
				end if;
			end if;
		end if;
------------------------------------------------------------------------------
	Seg0_Cnt(3) := cnt(7);
	Seg0_Cnt(2) := cnt(6);
	Seg0_Cnt(1) := cnt(5);
	Seg0_Cnt(0) := cnt(4);
	Seg1_Cnt(3) := cnt(3);
	Seg1_Cnt(2) := cnt(2);
	Seg1_Cnt(1) := cnt(1);
	Seg1_Cnt(0) := cnt(0);
------------------------------------------------------------------------------
	case seg0_Cnt is
	when "0000" => seg0_Data <= "1111110"; --0
	when "0001" => seg0_Data <= "0110000"; --1
	when "0010" => seg0_Data <= "1101101"; --2
	when "0011" => seg0_Data <= "1111001"; --3
	when "0100" => seg0_Data <= "0110011"; --4
	when "0101" => seg0_Data <= "1011011"; --5
	when "0110" => seg0_Data <= "1011111"; --6
	when "0111" => seg0_Data <= "1110000"; --7
	when "1000" => seg0_Data <= "1111111"; --8
	when "1001" => seg0_Data <= "1111011"; --9
	when "1010" => seg0_Data <= "1110111"; --A
	when "1011" => seg0_Data <= "1111111"; --B
	when "1100" => seg0_Data <= "1001110"; --C
	when "1101" => seg0_Data <= "1111110"; --D
	when "1110" => seg0_Data <= "1001111"; --E
	when others => seg0_Data <= "1000111"; --F
	end case;
------------------------------------------------------------------------------
	case seg1_Cnt is
	when "0000" => seg1_Data <= "1111110"; --0
	when "0001" => seg1_Data <= "0110000"; --1
	when "0010" => seg1_Data <= "1101101"; --2
	when "0011" => seg1_Data <= "1111001"; --3
	when "0100" => seg1_Data <= "0110011"; --4
	when "0101" => seg1_Data <= "1011011"; --5
	when "0110" => seg1_Data <= "1011111"; --6
	when "0111" => seg1_Data <= "1110000"; --7
	when "1000" => seg1_Data <= "1111111"; --8
	when "1001" => seg1_Data <= "1111011"; --9
	when "1010" => seg1_Data <= "1110111"; --A
	when "1011" => seg1_Data <= "1111111"; --B
	when "1100" => seg1_Data <= "1001110"; --C
	when "1101" => seg1_Data <= "1111110"; --D
	when "1110" => seg1_Data <= "1001111"; --E
	when others => seg1_Data <= "1000111"; --F
	end case;
end process;
------------------------------------------------------------------------------
seg0(0) <= not seg0_Data(6);
seg0(1) <= not seg0_Data(5);
seg0(2) <= not seg0_Data(4);
seg0(3) <= not seg0_Data(3);
seg0(4) <= not seg0_Data(2);
seg0(5) <= not seg0_Data(1);
seg0(6) <= not seg0_Data(0);

seg1(0) <= not seg1_Data(6);
seg1(1) <= not seg1_Data(5);
seg1(2) <= not seg1_Data(4);
seg1(3) <= not seg1_Data(3);
seg1(4) <= not seg1_Data(2);
seg1(5) <= not seg1_Data(1);
seg1(6) <= not seg1_Data(0);
	
end ckt;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
entity slowclk is
port(clk: in std_logic;
		clkout: out std_logic);
end slowclk;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
architecture ckt of slowclk is

begin
	process(clk)
	variable cnt: integer range 0 to 6750000;
	begin
		if (clk'event and clk ='1') then
			if cnt = 6750000 then
				cnt := 0;
				clkout <= '1';
			else
				cnt := cnt + 1;
				clkout <= '0';
			end if;
		end if;
	end process;
end ckt;
------------------------------------------------------------------------------
------------------------------------------------------------------------------