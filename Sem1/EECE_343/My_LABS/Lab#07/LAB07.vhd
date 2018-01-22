----------------------------------LAB07------------------------------------------
------------------------------Vending Machine------------------------------------
-----------------------------------By--------------------------------------------
-----------------------------Hitesh Vijay Oswal----------------------------------
-----------------------------------and-------------------------------------------
--------------------------------Omkar Sali---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.LCD_String_DataType.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
Entity Lab07 is
Port(	clk, Enable, Reset			: in std_logic;
		Money								: in std_logic_vector(3 downto 0);
		Chips_In, Cola_In				: in std_logic;
		En_Out, Res_Out				: out std_logic;
		Chips_Out						: out std_logic;
		Cola_Out							: out std_logic;
		Nic_Out, Dim_out, Qut_Out	: out std_logic;
		Seg0, Seg1, Seg2, Seg3		: out std_logic_vector(6 downto 0);
		Seg4, Seg5, Seg6, Seg7		: out std_logic_vector(6 downto 0);
		LCD_RS, LCD_E          		: out std_logic;
      LCD_RW                 		: out std_logic;
      LCD_ON                 		: out std_logic;
      LCD_BLON               		: out std_logic;
      DATA_BUS               		: inout std_logic_vector (7 downto 0));
end Lab07;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
architecture ckt of Lab07 is

type S_state is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, S32, S33, S34, S35, S36, S37, S38, S39, S40, MAX);

signal Clk_In : std_logic;
signal State : S_state;
signal Seg_Data : std_logic_vector (11 downto 0);
signal Seg_Data_BCD : std_logic_vector (19 downto 0);
signal LCD_String_Data : character_string;
signal LCD_Disp : std_logic_vector (5 downto 0);
signal N_Count, D_Count, Q_Count : std_logic_vector (3 downto 0) := "0000";
signal Count : std_logic_vector (11 downto 0) := (Others => '0');
signal Count_BCD : std_logic_vector (19 downto 0);
---------------------------------------------------------------------------------
component slowclk is
port(clk: in std_logic;
		clkout: out std_logic);
end component;
---------------------------------------------------------------------------------
component Binary_to_BCD is
port(Bin: in std_logic_vector (17 downto 0);
		BCDout: out std_logic_vector (19 downto 0));
end component;
---------------------------------------------------------------------------------
component SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end component;
---------------------------------------------------------------------------------
component LCD_String is 
Port(	Input : in std_logic_vector(5 downto 0);
		In_Data_N : in std_logic_vector(3 downto 0);
		In_Data_D : in std_logic_vector(3 downto 0);
		In_Data_Q : in std_logic_vector(3 downto 0);
		Output : out character_string);
end component;
---------------------------------------------------------------------------------
component LCD_Display IS
PORT(	reset, CLOCK_50       	: IN  STD_LOGIC;
		string_Data       	   : IN    character_string;
		LCD_RS, LCD_E          	: OUT STD_LOGIC;
		LCD_RW                 	: OUT   STD_LOGIC;
		LCD_ON                	: OUT STD_LOGIC;
		LCD_BLON             	: OUT STD_LOGIC;
		DATA_BUS             	: INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
      
end  component;
---------------------------------------------------------------------------------
begin

Stage1: slowclk port map (clk, Clk_In);

process(Clk_In, Chips_In, Cola_In, Money)
begin

En_Out <= Enable;
Res_Out <= Reset;

if (Clk_In'event and Clk_In = '1') then
	if Enable = '0' then
		State <= S0;
		Chips_Out <= '0';
		Cola_Out <= '0';
		N_Count <= "0000";
		D_Count <= "0000";
		Q_Count <= "0000";
		LCD_Disp <= "000000";
		Count <= (others => '0');
	elsif Enable = '1' then
		LCD_Disp <= "000001";
		if Reset = '1' then 
			State <= S0;
			Chips_Out <= '0';
			Cola_Out <= '0';
			N_Count <= "0000";
			D_Count <= "0000";
			Q_Count <= "0000";
			Count <= (others => '0');
		end if;
		case State is
		when S0=>
			Seg_Data <= "000000000000"; --0.00
			LCD_Disp <= "000001";
			if Money = "1111" then
				if (Chips_In = '1') then
					State <= S0;
					LCD_Disp <= "000010";
				elsif (Cola_In = '1') then
					State <= S0;
					LCD_Disp <= "000010";
				else
					Chips_Out <= '0';
					Cola_Out <= '0';
					N_Count <= "0000";
					D_Count <= "0000";
					Q_Count <= "0000";
					Count <= (others => '0');
					State <= S0;
				end if;
			elsif Money = "1110" then State <= S1;
			elsif Money = "1101" then State <= S2;
			elsif Money = "1011" then State <= S5;
			elsif Money = "0111" then State <= S20;
			end if;
			
		when S1=>
			Seg_Data <= "000000000101"; --0.05
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S1;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S1;
				end if;
			elsif Money = "1110" then State <= S2;
			elsif Money = "1101" then State <= S3;
			elsif Money = "1011" then State <= S6;
			elsif Money = "0111" then State <= S21;
			end if;
			
		when S2=>
			Seg_Data <= "000000001010"; --0.10
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S2;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S2;
				end if;
			elsif Money = "1110" then State <= S3;
			elsif Money = "1101" then State <= S4;
			elsif Money = "1011" then State <= S7;
			elsif Money = "0111" then State <= S22;
			end if;
			
		when S3=>
			Seg_Data <= "000000001111"; --0.15
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S3;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S3;
				end if;
			elsif Money = "1110" then State <= S4;
			elsif Money = "1101" then State <= S5;
			elsif Money = "1011" then State <= S8;
			elsif Money = "0111" then State <= S23;
			end if;
			
		when S4=>
			Seg_Data <= "000000010100"; --0.20
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S4;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S4;
				end if;
			elsif Money = "1110" then State <= S5;
			elsif Money = "1101" then State <= S6;
			elsif Money = "1011" then State <= S9;
			elsif Money = "0111" then State <= S24;
			end if;
			
		when S5=>
			Seg_Data <= "000000011001"; --0.25
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S5;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '1';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S0;
				end if;
				elsif Money = "1110" then State <= S6;
				elsif Money = "1101" then State <= S7;
				elsif Money = "1011" then State <= S10;
				elsif Money = "0111" then State <= S25;
			end if;
			
		when S6=>
			Seg_Data <= "000000011110"; --0.30
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '1';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S0;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '1';
					N_Count <= N_Count + 1;
					Count <= Count + 5;
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S5;
				end if;
				elsif Money = "1110" then State <= S7;
				elsif Money = "1101" then State <= S8;
				elsif Money = "1011" then State <= S11;
				elsif Money = "0111" then State <= S26;
			end if;
			
		when S7=>
			Seg_Data <= "000000100011"; --0.35
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '1';
					N_Count <= N_Count + 1;
					Count <= Count + 5;
					Dim_Out <= '0';
					Qut_Out<= '0';
					State <= S6;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '1';
					D_Count <= D_Count + 1;
					Count <= Count + 10;
					Qut_Out<= '0';
					State <= S5;
				end if;
				elsif Money = "1110" then State <= S8;
				elsif Money = "1101" then State <= S9;
				elsif Money = "1011" then State <= S12;
				elsif Money = "0111" then State <= S27;
			end if;
		
		when S8=>
			Seg_Data <= "000000101000"; --0.40
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '1';
					D_Count <= D_Count + 1;
					Count <= Count + 10;
					Qut_Out<= '0';
					State <= S6;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '1';
					N_Count <= N_Count + 1;
					Count <= Count + 5;
					Dim_Out <= '1';
					D_Count <= D_Count + 1;
					Count <= Count + 10;
					Qut_Out<= '0';
					State <= S5;
				end if;
				elsif Money = "1110" then State <= S9;
				elsif Money = "1101" then State <= S10;
				elsif Money = "1011" then State <= S13;
				elsif Money = "0111" then State <= S28;
			end if;
			
		when S9=>
			Seg_Data <= "000000101101"; --0.45
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '1';
					N_Count <= N_Count + 1;
					Count <= Count + 5;
					Dim_Out <= '1';
					D_Count <= D_Count + 1;
					Count <= Count + 10;
					Qut_Out<= '0';
					State <= S6;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '1';
					D_Count <= D_Count + 1;
					Count <= Count + 10;
					Qut_Out<= '0';
					State <= S7;
				end if;
				elsif Money = "1110" then State <= S10;
				elsif Money = "1101" then State <= S11;
				elsif Money = "1011" then State <= S14;
				elsif Money = "0111" then State <= S29;
			end if;
		
		
		when S10=>
			Seg_Data <= "000000110010"; --0.50
			LCD_Disp <= "000010";
			if Money = "1111" then
				if (Chips_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '1';
					D_Count <= D_Count + 1;
					Count <= Count + 10;
					Qut_Out<= '0';
					State <= S8;
				elsif (Cola_In = '1') then
					Chips_Out <= '0';
					Cola_Out <= '0';
					Nic_Out <= '0';
					Dim_Out <= '0';
					Qut_Out<= '1';
					Q_Count <= Q_Count + 1;
					Count <= Count + 25;
					State <= S5;
				end if;
				elsif Money = "1110" then State <= S11;
				elsif Money = "1101" then State <= S12;
				elsif Money = "1011" then State <= S15;
				elsif Money = "0111" then State <= S30;
			end if;
		
		
		when S11=>
			Seg_Data <= "000000110111"; --0.55
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S6;
			end if;
			elsif Money = "1110" then State <= S12;
			elsif Money = "1101" then State <= S13;
			elsif Money = "1011" then State <= S16;
			elsif Money = "0111" then State <= S31;
			end if;
		
		
		when S12=>
			Seg_Data <= "000000111100"; --0.60
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S7;
			end if;
			elsif Money = "1110" then State <= S13;
			elsif Money = "1101" then State <= S14;
			elsif Money = "1011" then State <= S17;
			elsif Money = "0111" then State <= S32;
			end if;
		
		
		when S13=>
			Seg_Data <= "000001000001"; --0.65
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S8;
			end if;
			elsif Money = "1110" then State <= S14;
			elsif Money = "1101" then State <= S15;
			elsif Money = "1011" then State <= S18;
			elsif Money = "0111" then State <= S33;
			end if;
		
		
		when S14=>
			Seg_Data <= "000001000110"; --0.70
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S9;
			end if;
			elsif Money = "1110" then State <= S15;
			elsif Money = "1101" then State <= S16;
			elsif Money = "1011" then State <= S19;
			elsif Money = "0111" then State <= S34;
			end if;
		
		
		when S15=>
			Seg_Data <= "000001001011"; --0.75
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S10;
			end if;
			elsif Money = "1110" then State <= S16;
			elsif Money = "1101" then State <= S17;
			elsif Money = "1011" then State <= S20;
			elsif Money = "0111" then State <= S35;
			end if;
		
		
		when S16=>
			Seg_Data <= "000001010000"; --0.80
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S11;
			end if;
			elsif Money = "1110" then State <= S17;
			elsif Money = "1101" then State <= S18;
			elsif Money = "1011" then State <= S21;
			elsif Money = "0111" then State <= S36;
			end if;
		
		
		when S17=>
			Seg_Data <= "000001010101"; --0.85
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S12;
			end if;
			elsif Money = "1110" then State <= S18;
			elsif Money = "1101" then State <= S19;
			elsif Money = "1011" then State <= S22;
			elsif Money = "0111" then State <= S37;
			end if;
		
		when S18=>
			Seg_Data <= "000001011010"; --0.90
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S13;
			end if;
			elsif Money = "1110" then State <= S19;
			elsif Money = "1101" then State <= S20;
			elsif Money = "1011" then State <= S23;
			elsif Money = "0111" then State <= S38;
			end if;
		
		
		when S19=>
			Seg_Data <= "000001011111"; --0.95
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S14;
			end if;
			elsif Money = "1110" then State <= S20;
			elsif Money = "1101" then State <= S21;
			elsif Money = "1011" then State <= S24;
			elsif Money = "0111" then State <= S39;
			end if;
		
		
		when S20=>
			Seg_Data <= "000001100100"; --1.00
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S15;
			end if;
			elsif Money = "1110" then State <= S21;
			elsif Money = "1101" then State <= S22;
			elsif Money = "1011" then State <= S25;
			elsif Money = "0111" then State <= S40;
			end if;
		
		
		when S21=>
			Seg_Data <= "000001101001"; --1.05
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S16;
			end if;
			elsif Money = "1110" then State <= S22;
			elsif Money = "1101" then State <= S23;
			elsif Money = "1011" then State <= S26;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		
		when S22=>
			Seg_Data <= "000001101110"; --1.10
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S17;
			end if;
			elsif Money = "1110" then State <= S23;
			elsif Money = "1101" then State <= S24;
			elsif Money = "1011" then State <= S27;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S23=>
			Seg_Data <= "000001110011"; --1.15
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S18;
			end if;
			elsif Money = "1110" then State <= S24;
			elsif Money = "1101" then State <= S25;
			elsif Money = "1011" then State <= S28;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S24=>
			Seg_Data <= "000001111000"; --1.20
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S19;
			end if;
			elsif Money = "1110" then State <= S25;
			elsif Money = "1101" then State <= S26;
			elsif Money = "1011" then State <= S29;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S25=>
			Seg_Data <= "000001111101"; --1.25
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S20;
			end if;
			elsif Money = "1110" then State <= S26;
			elsif Money = "1101" then State <= S27;
			elsif Money = "1011" then State <= S30;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S26=>
			Seg_Data <= "000010000010"; --1.30
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S21;
			end if;
			elsif Money = "1110" then State <= S27;
			elsif Money = "1101" then State <= S28;
			elsif Money = "1011" then State <= S31;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S27=>
			Seg_Data <= "000010000111"; --1.35
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S22;
			end if;
			elsif Money = "1110" then State <= S28;
			elsif Money = "1101" then State <= S29;
			elsif Money = "1011" then State <= S32;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S28=>
			Seg_Data <= "000010001100"; --1.40
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S23;
			end if;
			elsif Money = "1110" then State <= S29;
			elsif Money = "1101" then State <= S30;
			elsif Money = "1011" then State <= S33;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S29=>
			Seg_Data <= "000010010001"; --1.45
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S24;
			end if;
			elsif Money = "1110" then State <= S30;
			elsif Money = "1101" then State <= S31;
			elsif Money = "1011" then State <= S34;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S30=>
			Seg_Data <= "000010010110"; --1.50
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S25;
			end if;
			elsif Money = "1110" then State <= S31;
			elsif Money = "1101" then State <= S32;
			elsif Money = "1011" then State <= S35;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S31=>
			Seg_Data <= "000010011011"; --1.55
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S26;
			end if;
			elsif Money = "1110" then State <= S32;
			elsif Money = "1101" then State <= S33;
			elsif Money = "1011" then State <= S36;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S32=>
			Seg_Data <= "000010100000"; --1.60
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S27;
			end if;
			elsif Money = "1110" then State <= S33;
			elsif Money = "1101" then State <= S34;
			elsif Money = "1011" then State <= S37;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S33=>
			Seg_Data <= "000010100101"; --1.65
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S28;
			end if;
			elsif Money = "1110" then State <= S34;
			elsif Money = "1101" then State <= S35;
			elsif Money = "1011" then State <= S38;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S34=>
			Seg_Data <= "000010101010"; --1.70
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S29;
			end if;
			elsif Money = "1110" then State <= S35;
			elsif Money = "1101" then State <= S36;
			elsif Money = "1011" then State <= S39;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S35=>
			Seg_Data <= "000010101111"; --1.75
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S30;
			end if;
			elsif Money = "1110" then State <= S36;
			elsif Money = "1101" then State <= S37;
			elsif Money = "1011" then State <= S40;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S36=>
			Seg_Data <= "000010110100"; --1.80
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S31;
			end if;
			elsif Money = "1110" then State <= S37;
			elsif Money = "1101" then State <= S38;
			elsif Money = "1011" then State <= MAX;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S37=>
			Seg_Data <= "000010111001"; --1.85
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S32;
			end if;
			elsif Money = "1110" then State <= S38;
			elsif Money = "1101" then State <= S39;
			elsif Money = "1011" then State <= MAX;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S38=>
			Seg_Data <= "000010111110"; --1.90
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S33;
			end if;
			elsif Money = "1110" then State <= S39;
			elsif Money = "1101" then State <= S40;
			elsif Money = "1011" then State <= MAX;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when S39=>
			Seg_Data <= "000011000011"; --1.95
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S34;
			end if;
			elsif Money = "1110" then State <= S40;
			elsif Money = "1101" then State <= MAX;
			elsif Money = "1011" then State <= MAX;
			elsif Money = "0111" then State <= MAX;
			end if;
		
		when S40=>
			Seg_Data <= "000011001000"; --2.00
			LCD_Disp <= "000010";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				Chips_Out <= '0';
				Cola_Out <= '0';
				Nic_Out <= '0';
				Dim_Out <= '0';
				Qut_Out<= '1';
				Q_Count <= Q_Count + 1;
				Count <= Count + 25;
				State <= S35;
			end if;
			elsif Money = "1110" then State <= MAX;
			elsif Money = "1101" then State <= MAX;
			elsif Money = "1011" then State <= MAX;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		when MAX=>
			Seg_Data <= "000011001000"; --2.00
			LCD_Disp <= "000011";
			if Money = "1111" then
			if (Chips_In = '1' or Cola_In = '1') then
				State <= S40;
			end if;
			elsif Money = "1110" then State <= MAX;
			elsif Money = "1101" then State <= MAX;
			elsif Money = "1011" then State <= MAX;
			elsif Money = "0111" then State <= MAX;
			end if;
			
		end case;
	end if;
end if;
end process;

stage2: Binary_to_BCD port map ("000000" & Seg_Data, Seg_Data_BCD);
Sege0: SevSegDisp port map (Seg_Data_BCD(3 downto 0), Seg0);
Sege1: SevSegDisp port map (Seg_Data_BCD(7 downto 4), Seg1);
Seg2 <= "1110111";
Sege2: SevSegDisp port map (Seg_Data_BCD(11 downto 8), Seg3);
stage3: Binary_to_BCD port map ("000000" & Count, Count_BCD);
Sege3: SevSegDisp port map (Count_BCD(3 downto 0), Seg4);
Sege4: SevSegDisp port map (Count_BCD(7 downto 4), Seg5);
Seg6 <= "1110111";
Sege5: SevSegDisp port map (Count_BCD(11 downto 8), Seg7);

LCDSTR: LCD_String port map (LCD_Disp, N_Count, D_Count, Q_Count, LCD_String_Data);

LCSDISP: LCD_Display port map ('1', Clk, LCD_String_Data, LCD_RS, LCD_E, LCD_RW, LCD_ON, LCD_BLON, DATA_BUS);

end ckt;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

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
	variable cnt: integer range 0 to 12500000;
	begin
		if (clk'event and clk ='1') then
			if cnt = 12500000 then
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
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
package LCD_String_DataType is
	TYPE character_string IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 7 DOWNTO 0 );
end package;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.LCD_String_DataType.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
entity LCD_String is 
Port(	Input : in std_logic_vector(5 downto 0);
		In_Data_N : in std_logic_vector(3 downto 0);
		In_Data_D : in std_logic_vector(3 downto 0);
		In_Data_Q : in std_logic_vector(3 downto 0);
		Output : out character_string);
end LCD_String;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
architecture ckt of LCD_String is
begin
process(Input)
begin
---------------------------------------------------------------------------------
if Input = "000000" then
Output <= (
-- Line 1----MACHINE CLOSED
   X"20",X"4D",X"41",X"43",X"48",X"49",X"4E",X"45",
	X"20",X"43",X"4C",X"4F",X"53",X"45",X"44",X"20",
-- Line 2----SWITCH ON SW1
   X"20",X"53",X"57",X"49",X"54",X"43",X"48",X"20",
	X"4F",X"4E",X"20",X"53",X"57",X"31",X"20",X"20");
---------------------------------------------------------------------------------
elsif Input = "000001" then
Output <= (
-- Line 1----WELCOME!!!
   X"20",X"20",X"20",X"57",X"45",X"4C",X"43",X"4F",
	X"4D",X"45",X"21",X"21",X"21",X"20",X"20",X"20",
-- Line 2----CHIPS:30 COCA:25
   X"43",X"48",X"49",X"50",X"53",X"3A",X"33",X"30",
	X"20",X"43",X"4F",X"43",X"41",X"3A",X"32",X"35");
---------------------------------------------------------------------------------
elsif Input = "000010" then
Output <= (
-- Line 1-----RET N:X D:X Q:X
   X"52",X"45",X"54",X"20",X"4E",X"3A",X"0" & In_Data_N,X"20",X"44",
	X"3A",X"0" & In_Data_D,X"20",X"51",X"3A",X"0" & In_Data_Q,X"20",
-- Line 2----CHIPS:30 COLA:25
   X"43",X"48",X"49",X"50",X"53",X"3A",X"33",X"30",
	X"20",X"43",X"4F",X"43",X"41",X"3A",X"32",X"35");
---------------------------------------------------------------------------------
elsif Input = "000011" then
Output <= (
-- Line 1-----MAX AMOUNT 2.00
   X"4D",X"41",X"58",X"20",X"41",X"4D",X"4F",X"55",
	X"4E",X"54",X"20",X"32",X"2E",X"30",X"30",X"20",
-- Line 2-----SELECT PRODUCT
   X"53",X"45",X"4C",X"45",X"43",X"54",X"20",X"50",
	X"52",X"4F",X"44",X"55",X"43",X"54",X"20",X"20");
---------------------------------------------------------------------------------
end if;
end process;
end ckt;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
use work.LCD_String_DataType.all;
 
ENTITY LCD_Display IS
-- Enter number of live Hex hardware data values to display
-- (do not count ASCII character constants)
-----------------------------------------------------------------------
-- LCD Displays 16 Characters on 2 lines
-- LCD_display string is an ASCII character string entered in hex for 
-- the two lines of the  LCD Display   (See ASCII to hex table below)
-- Edit LCD_Display_String entries above to modify display
-- Enter the ASCII character's 2 hex digit equivalent value
-- (see table below for ASCII hex values)
-- To display character assign ASCII value to LCD_display_string(x)
-- To skip a character use X"20" (ASCII space)
-- To dislay "live" hex values from hardware on LCD use the following: 
--   make array element for that character location X"0" & 4-bit field from Hex_Display_Data
--   state machine sees X"0" in high 4-bits & grabs the next lower 4-bits from Hex_Display_Data input
--   and performs 4-bit binary to ASCII conversion needed to print a hex digit
--   Num_Hex_Digits must be set to the count of hex data characters (ie. "00"s) in the display
--   Connect hardware bits to display to Hex_Display_Data input
-- To display less than 32 characters, terminate string with an entry of X"FE"
--  (fewer characters may slightly increase the LCD's data update rate)
------------------------------------------------------------------- 
--                        ASCII HEX TABLE
--  Hex                 Low Hex Digit
-- Value  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
------\----------------------------------------------------------------
--H  2 |  SP  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
--i  3 |  0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
--g  4 |  @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
--h  5 |  P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
--   6 |  `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
--   7 |  p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~ DEL
-----------------------------------------------------------------------
-- Example "A" is row 4 column 1, so hex value is X"41"
-- *see LCD Controller's Datasheet for other graphics characters available
--
   PORT(reset, CLOCK_50       : IN  STD_LOGIC;
       string_Data       	   : IN    character_string;
       LCD_RS, LCD_E          : OUT STD_LOGIC;
       LCD_RW                 : OUT   STD_LOGIC;
       LCD_ON                 : OUT STD_LOGIC;
       LCD_BLON               : OUT STD_LOGIC;
       DATA_BUS               : INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
      
END ENTITY LCD_Display;

ARCHITECTURE Behavior OF LCD_Display IS
TYPE STATE_TYPE IS (HOLD, FUNC_SET, DISPLAY_ON, MODE_SET, Print_String,
               LINE2, RETURN_HOME, DROP_LCD_E, RESET1, RESET2, 
               RESET3, DISPLAY_OFF, DISPLAY_CLEAR);

SIGNAL   state, next_command           : STATE_TYPE;
SIGNAL   LCD_display_string            : character_string;

-- Enter new ASCII hex data above for LCD Display

SIGNAL   DATA_BUS_VALUE, Next_Char     : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL   CLK_COUNT_400HZ               : STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL   CHAR_COUNT                 	: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL   CLK_400HZ_Enable,LCD_RW_INT   : STD_LOGIC;
SIGNAL   Line1_chars, Line2_chars      : STD_LOGIC_VECTOR(127 DOWNTO 0);
BEGIN

LCD_ON      <= '1';
LCD_BLON    <= '1';

LCD_display_string <= string_Data;
-- BIDIRECTIONAL TRI STATE LCD DATA BUS
   DATA_BUS <= DATA_BUS_VALUE WHEN LCD_RW_INT = '0' ELSE "ZZZZZZZZ";

-- get next character in display string
   Next_Char <= LCD_display_string(CONV_INTEGER(CHAR_COUNT));
   LCD_RW <= LCD_RW_INT;
   
   PROCESS
   BEGIN
    WAIT UNTIL CLOCK_50'EVENT AND CLOCK_50 = '1';
      IF RESET = '0' THEN
       CLK_COUNT_400HZ <= X"00000";
       CLK_400HZ_Enable <= '0';
      ELSE
            IF CLK_COUNT_400HZ < X"0F424" THEN 
             CLK_COUNT_400HZ <= CLK_COUNT_400HZ + 1;
             CLK_400HZ_Enable <= '0';
            ELSE
             CLK_COUNT_400HZ <= X"00000";
             CLK_400HZ_Enable <= '1';
            END IF;
      END IF;
   END PROCESS;

   PROCESS (CLOCK_50, reset)
   BEGIN
      IF reset = '0' THEN
         state <= RESET1;
         DATA_BUS_VALUE <= X"38";
         next_command <= RESET2;
         LCD_E <= '1';
         LCD_RS <= '0';
         LCD_RW_INT <= '0';

      ELSIF CLOCK_50'EVENT AND CLOCK_50 = '1' THEN
-- State Machine to send commands and data to LCD DISPLAY         
        IF CLK_400HZ_Enable = '1' THEN
         CASE state IS
-- Set Function to 8-bit transfer and 2 line display with 5x8 Font size
-- see Hitachi HD44780 family data sheet for LCD command and timing details
            WHEN RESET1 =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"38";
                  state <= DROP_LCD_E;
                  next_command <= RESET2;
                  CHAR_COUNT <= "00000";
            WHEN RESET2 =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"38";
                  state <= DROP_LCD_E;
                  next_command <= RESET3;
            WHEN RESET3 =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"38";
                  state <= DROP_LCD_E;
                  next_command <= FUNC_SET;
-- EXTRA STATES ABOVE ARE NEEDED FOR RELIABLE PUSHBUTTON RESET OF LCD
            WHEN FUNC_SET =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"38";
                  state <= DROP_LCD_E;
                  next_command <= DISPLAY_OFF;
-- Turn off Display and Turn off cursor
            WHEN DISPLAY_OFF =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"08";
                  state <= DROP_LCD_E;
                  next_command <= DISPLAY_CLEAR;
-- Clear Display and Turn off cursor
            WHEN DISPLAY_CLEAR =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"01";
                  state <= DROP_LCD_E;
                  next_command <= DISPLAY_ON;
-- Turn on Display and Turn off cursor
            WHEN DISPLAY_ON =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"0C";
                  state <= DROP_LCD_E;
                  next_command <= MODE_SET;
-- Set write mode to auto increment address and move cursor to the right
            WHEN MODE_SET =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"06";
                  state <= DROP_LCD_E;
                  next_command <= Print_String;
-- Write ASCII hex character in first LCD character location
            WHEN Print_String =>
                  state <= DROP_LCD_E;
                  LCD_E <= '1';
                  LCD_RS <= '1';
                  LCD_RW_INT <= '0';
-- ASCII character to output
                  IF Next_Char(7 DOWNTO  4) /= X"0" THEN
                  DATA_BUS_VALUE <= Next_Char;
                  ELSE
-- Convert 4-bit value to an ASCII hex digit
                     IF Next_Char(3 DOWNTO 0) >9 THEN
-- ASCII A...F
                      DATA_BUS_VALUE <= X"4" & (Next_Char(3 DOWNTO 0)-9);
                     ELSE
-- ASCII 0...9
                      DATA_BUS_VALUE <= X"3" & Next_Char(3 DOWNTO 0);
                     END IF;
                  END IF;
                  state <= DROP_LCD_E;
-- Loop to send out 32 characters to LCD Display  (16 by 2 lines)
                  IF (CHAR_COUNT < 31) AND (Next_Char /= X"FE") THEN 
                   CHAR_COUNT <= CHAR_COUNT +1;
                  ELSE 
                   CHAR_COUNT <= "00000"; 
                  END IF;
-- Jump to second line?
                  IF CHAR_COUNT = 15 THEN next_command <= line2;
-- Return to first line?
                  ELSIF (CHAR_COUNT = 31) OR (Next_Char = X"FE") THEN 
                   next_command <= return_home; 
                  ELSE next_command <= Print_String; END IF;
-- Set write address to line 2 character 1
            WHEN LINE2 =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"C0";
                  state <= DROP_LCD_E;
                  next_command <= Print_String;
-- Return write address to first character postion on line 1
            WHEN RETURN_HOME =>
                  LCD_E <= '1';
                  LCD_RS <= '0';
                  LCD_RW_INT <= '0';
                  DATA_BUS_VALUE <= X"80";
                  state <= DROP_LCD_E;
                  next_command <= Print_String;
-- The next three states occur at the end of each command or data transfer to the LCD
-- Drop LCD E line - falling edge loads inst/data to LCD controller
            WHEN DROP_LCD_E =>
                  LCD_E <= '0';
                  state <= HOLD;
-- Hold LCD inst/data valid after falling edge of E line          
            WHEN HOLD =>
                  state <= next_command;
         END CASE;
        END IF;
      END IF;
   END PROCESS;
END Behavior;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
entity Binary_to_BCD is
port(Bin: in std_logic_vector (17 downto 0);
		BCDout: out std_logic_vector (19 downto 0));
end Binary_to_BCD;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
architecture Ckt of Binary_to_BCD is
begin

process(Bin)
variable B : std_logic_vector (17 downto 0);
variable BCD : std_logic_vector (19 downto 0);
begin

B := Bin;
BCD := (others => '0');

for i in 0 to 17 loop

if BCD(3 downto 0) > "0100" then
	BCD(3 downto 0) := BCD(3 downto 0) + "0011";
end if;

if BCD(7 downto 4) > "0100" then
	BCD(7 downto 4) := BCD(7 downto 4) + "0011";
end if;

if BCD(11 downto 8) > "0100" then
	BCD(11 downto 8) := BCD(11 downto 8) + "0011";
end if;

if BCD(15 downto 12) > "0100" then
	BCD(15 downto 12) := BCD(15 downto 12) + "0011";
end if;

if BCD(19 downto 16) > "0100" then
	BCD(19 downto 16) := BCD(19 downto 16) + "0011";
end if;

BCD := BCD(18 downto 0) & B(17);
B := B(16 downto 0) & '0';

end loop;

BCDout <= BCD;

end process;
end Ckt;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------