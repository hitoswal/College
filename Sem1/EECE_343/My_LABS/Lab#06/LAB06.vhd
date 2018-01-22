----------------------------------LAB06------------------------------------------
--------------------------9-BIT Sequence Detector--------------------------------
-----------------------------------By--------------------------------------------
-----------------------------Hitesh Vijay Oswal----------------------------------
-----------------------------------and-------------------------------------------
--------------------------------Omkar Sali---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.LCD_String_DataType.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
Entity Lab06 is
port(	clk, reset, Load, Enable	: in std_logic;
		Input 							: in std_logic_vector (8 downto 0);
		Out_LEDs							: out std_logic_vector (8 downto 0);
		Seg1, Seg2, Seg3, Seg4		: out std_logic_vector (6 downto 0);
		LCD_RS, LCD_E          		: OUT STD_LOGIC;
      LCD_RW                 		: OUT STD_LOGIC;
      LCD_ON                 		: OUT STD_LOGIC;
      LCD_BLON               		: OUT STD_LOGIC;
      DATA_BUS               		: inout std_logic_vector (7 downto 0));
end Lab06;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
architecture ckt of Lab06 is

component SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end component;
---------------------------------------------------------------------------------
component slowclk is
port(	clk: in std_logic;
		clkout: out std_logic);
end component;
---------------------------------------------------------------------------------
component LCD_String is 
Port(	Input : in std_logic_vector(3 downto 0);
		In_Data : in std_logic_vector(8 downto 0);
		Output : out character_string);
end component;
---------------------------------------------------------------------------------
component LCD_Display is
PORT(	reset, CLOCK_50       	: IN  STD_LOGIC;
      string_Data					: in character_string;
      LCD_RS, LCD_E          	: OUT STD_LOGIC;
      LCD_RW                 	: OUT STD_LOGIC;
      LCD_ON                 	: OUT STD_LOGIC;
      LCD_BLON               	: OUT STD_LOGIC;
      DATA_BUS               	: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;
---------------------------------------------------------------------------------
type S_state is (S0, S1, S2, S3, S4, S5, S6, S7, S8);

signal In_data 						: std_logic_vector (8 downto 0) := (others => '0');
signal LCD_display_string 			: character_string;
signal State 							: S_state;
signal output							: std_logic; 
signal clkin							: std_logic;
signal LCD_Out							: std_logic_vector (3 downto 0);
signal Sig								: std_logic_vector (3 downto 0);
signal Flag								: std_logic;
---------------------------------------------------------------------------------
begin

Stage0: slowclk port map (clk, clkin);
process(clkin, Enable)
	begin
if (clkin'event and clkin = '1') then
		if reset = '0' then
			In_data <= "000000000";
			Out_LEDs <= "000000000";
			Sig <= "0000";
			State <= S0;
		end if;
		if Load = '0' then
			In_data <= Input;
			Out_LEDs <= Input;
			Sig <= "0000";
			State <= S0;
		else
			if Enable = '1' then
				if Flag = '1' then
					case State is
					
					when S0 =>
						if(In_data(8) = '1') then
							output <= '0';
							State <= S1;
							Sig <= "0001";
						else
							output <= '0';
							State <= S0;
							Sig <= "1010";
						end if;
					
					when S1 =>
						if(In_data(7) = '1') then
							output <= '0';
							State <= S2;
							Sig <= "0010";
						else
							output <= '0';
							State <= S0;
							Sig <= "1010";
						end if;
					
					when S2 =>
						if(In_data(6) = '0')then
							output <= '0';
							State <= S3;
							Sig <= "0011";
						else
							output <= '0';
							State <= S1;
							Sig <= "1010";
						end if;
						
					when S3 =>
						if(In_data(5) = '1') then
							output <= '0';
							State <= S4;
							Sig <= "0100";
						else
							output <= '0';
							State <= S0;
							Sig <= "1010";
						end if;
						
					when S4 =>
						if(In_data(4) = '1') then
							output <= '0';
							State <= S5;
							Sig <= "0101";
						else
							output <= '0';
							State <= S0;
							Sig <= "1010";
						end if;
						
					when S5 =>
						if(In_data(3) = '0') then
							output <= '0';
							State <= S6;
							Sig <= "0110";
						else
							output <= '0';
							State <= S1;
							Sig <= "1010";
						end if;
						
					when S6 =>
						if(In_data(2) = '1') then
							output <= '0';
							State <= S7;
							Sig <= "0111";
						else
							output <= '0';
							State <= S0;
							Sig <= "1010";
						end if;
						
					when S7 =>
						if(In_data(1) = '0') then
							output <= '0';
							State <= S8;
							Sig <= "1000";
						else
							output <= '0';
							State <= S1;
							Sig <= "1010";
						end if;
						
					when S8 =>
						if(In_data(0) = '1') then
							output <= '1';
							State <= S0;
							Sig <= "1011";
						else
							output <= '0';
							State <= S0;
							Sig <= "1010";
						end if;
					end case;
				end if;
			end if;
		end if;
	end if;
---------------------------------------------------------------------------------
	if Sig = "0000" or Sig < "1001" then
		Flag <= '1';
	elsif Sig > "1001" then
		Flag <= '0';
	end if;
	
end process;
---------------------------------------------------------------------------------
Stage1: SevSegDisp port map (In_data(3 downto 0), Seg1);
Stage2: SevSegDisp port map (In_data(7 downto 4), Seg2);
Stage3: SevSegDisp port map ("000" & In_data(8), Seg3);
Stage4: SevSegDisp port map ("000" & output, Seg4);

stage5: LCD_String port map (Sig, In_data, LCD_display_string);

stage6: LCD_Display port map (reset, clk, LCD_display_string, LCD_RS, LCD_E, LCD_RW, LCD_ON, LCD_BLON, DATA_BUS);
end ckt;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------