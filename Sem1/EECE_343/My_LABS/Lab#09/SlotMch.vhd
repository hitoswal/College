---------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.LCD_String_DataType.all;
---------------------------------------------------------
entity SlotMch is
generic(	T1	:	natural := 1;
			T2 :  natural := 2;
			T3 :	natural := 3);
port (clk, rst, input	:	in std_logic;
		Seg1, Seg2, Seg3		:	out std_logic_vector (6 downto 0);
		LEDR_Out	: buffer std_logic_vector(17 downto 0);
		LEDG_Out	: buffer std_logic_vector (7 downto 0);
		LCD_RS, LCD_E          : OUT STD_LOGIC;
      LCD_RW                 : OUT   STD_LOGIC;
      LCD_ON                 : OUT STD_LOGIC;
      LCD_BLON               : OUT STD_LOGIC;
      DATA_BUS               : INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_Red,VGA_Green,VGA_Blue,VGA_HSync,VGA_VSync,video_blank_out,Video_clock_out	:OUT std_logic);
end SlotMch;
----------------------------------------------------------
architecture fsm of SlotMch is

component SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end component;

component LCD_Display IS
PORT(reset, CLOCK_50       : IN  STD_LOGIC;
       string_Data       	   : IN    character_string;
       LCD_RS, LCD_E          : OUT STD_LOGIC;
       LCD_RW                 : OUT   STD_LOGIC;
       LCD_ON                 : OUT STD_LOGIC;
       LCD_BLON               : OUT STD_LOGIC;
       DATA_BUS               : INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0));
      
END component;

component LCD_String is 
Port(	Input : in std_logic_vector(2 downto 0);
		Output : out character_string);
end component;

component VGA_BALL IS
   PORT(clock_50Mhz	: IN std_logic;
			speed, size : in integer;
        VGA_Red,VGA_Green,VGA_Blue,VGA_HSync,VGA_VSync,video_blank_out,Video_clock_out	:OUT std_logic
        );		
END component;

type state is (zero, one, two, three, four, five, six, seven, eight, nine);

signal pr_state1, nx_state1, pr_state2, nx_state2, pr_state3, nx_state3: state;
signal output1, output2, output3 : natural range 0 to 9;
signal output_vec1, output_vec2, output_vec3 : std_logic_vector (3 downto 0);
signal button : std_logic := '0';
signal LEDG : std_logic_vector (7 downto 0) := (others => '1');
signal LEDR : std_logic_vector(17 downto 0) := (others => '0');
signal LCDString : std_logic_vector(2 downto 0);
signal str : character_string;
signal speed, size : integer;

attribute enum_encoding: string; --optional attribute
attribute enum_encoding of state: type is "sequential";

begin

LEDR_Out <= LEDR;
LEDG_Out <= LEDG;
----lower section of fsm:-----------
process (rst, clk, input)
variable cnt : natural range 0 to  15000000:= 0;
begin

if (input'event and input = '0') then
button <= button xor '1';
end if;

if (rst='0') then
pr_state1 <= zero;
pr_state2 <= zero;
pr_state3 <= zero;
elsif (clk'event and clk='1') then
cnt := cnt + 1;
if (button = '1')then
if (cnt = (T1 * 5000000)) then
pr_state1 <= nx_state1;
end if;
if (cnt = (T2 * 5000000)) then
pr_state2 <= nx_state2;
end if;
if (cnt = (T3 * 5000000)) then
pr_state3 <= nx_state3;
cnt := 0;
end if;
end if;
end if;
end process;
----upper section of fsm:-----------
process (pr_state1)
begin
case pr_state1 is
when zero =>
output1 <= 0;
nx_state1 <= one;
when one =>
output1 <= 1;
nx_state1 <= two;
when two =>
output1 <= 2;
nx_state1 <= three;
when three =>
output1 <= 3;
nx_state1 <= four;
when four =>
output1 <= 4;
nx_state1 <= five;
when five =>
output1 <= 5;
nx_state1 <= six;
when six =>
output1 <= 6;
nx_state1 <= seven;
when seven =>
output1 <= 7;
nx_state1 <= eight;
when eight =>
output1 <= 8;
nx_state1 <= nine;
when nine =>
output1 <= 9;
nx_state1 <= one;
end case;
end process;

----upper section of fsm:-----------
process (pr_state2)
begin
case pr_state2 is
when zero =>
output2 <= 0;
nx_state2 <= one;
when one =>
output2 <= 6;
nx_state2 <= two;
when two =>
output2 <= 5;
nx_state2 <= three;
when three =>
output2 <= 9;
nx_state2 <= four;
when four =>
output2 <= 4;
nx_state2 <= five;
when five =>
output2 <= 1;
nx_state2 <= six;
when six =>
output2 <= 8;
nx_state2 <= seven;
when seven =>
output2 <= 7;
nx_state2 <= eight;
when eight =>
output2 <= 2;
nx_state2 <= nine;
when nine =>
output2 <= 3;
nx_state2 <= one;
end case;
end process;

----upper section of fsm:-----------
process (pr_state3)
begin
case pr_state3 is
when zero =>
output3 <= 0;
nx_state3 <= one;
when one =>
output3 <= 9;
nx_state3 <= two;
when two =>
output3 <= 6;
nx_state3 <= three;
when three =>
output3 <= 3;
nx_state3 <= four;
when four =>
output3 <= 4;
nx_state3 <= five;
when five =>
output3 <= 8;
nx_state3 <= six;
when six =>
output3 <= 2;
nx_state3 <= seven;
when seven =>
output3 <= 7;
nx_state3 <= eight;
when eight =>
output3 <= 5;
nx_state3 <= nine;
when nine =>
output3 <= 1;
nx_state3 <= one;
end case;
end process;

process(clk, rst)
variable count : integer range 0 to 50000000 := 0;
begin
if (rst = '0') then
LEDG <= (others => '1');
LEDR <= (others => '0');
Speed <= 3;
Size <= 18;
elsif (clk'event and clk ='1') then
count := count + 1;
if (count = (T1 * 5000000)) then
if ((output1 = output2) and  (output2 = output3) and (output1 /= 0) and button = '0') then
LEDG <= (others => '1');
LEDR <= (others => '1');
LCDString <= "010";
Speed <= 12;
Size <= 45;
count := 0;
elsif ((((output1 /= output2) or  (output2 /= output3)) or (output1 /= output3)) and button = '0') then
LEDG <= (others => '0');
LEDR <= (others => '0');
LCDString <= "011";
Speed <= 1;
Size <= 10;
count := 0;
else
if (button = '0')then 
LCDString <= "000";
Speed <= 3;
Size <= 18;
else
LCDString <= "001";
Speed <= 6;
Size <= 18;
end if;
LEDG <= LEDG xor "11111111";
LEDR <= LEDR xor "111111111111111111";
count := 0;
end if;
end if;
end if;
end process;

output_vec1 <= conv_std_logic_vector(output1, 4);
disp1: SevSegDisp port map (output_vec1, seg1);
output_vec2 <= conv_std_logic_vector(output2, 4);
disp2: SevSegDisp port map (output_vec2, seg2);
output_vec3 <= conv_std_logic_vector(output3, 4);
disp3: SevSegDisp port map (output_vec3, seg3);

VGA: VGA_BALL port map (clk,speed, size, VGA_Red,VGA_Green,VGA_Blue,VGA_HSync,VGA_VSync,video_blank_out,Video_clock_out);

LCDstr: LCD_String port map (LCDString, str);
LCDdisp: LCD_Display port map (rst, clk, str, LCD_RS, LCD_E, LCD_RW, LCD_ON, LCD_BLON, DATA_BUS);
end fsm;
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
entity SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end SevSegDisp;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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
	when others => seg_Data <= "0000000"; ---
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
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.LCD_String_DataType.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
entity LCD_String is 
Port(	Input : in std_logic_vector(2 downto 0);
		Output : out character_string);
end LCD_String;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
architecture ckt of LCD_String is
begin
process(Input)
begin
---------------------------------------------------------------------------------
if Input = "000" then
Output <= (
-- Line 1----WELCOME!! PRESS
   X"57",X"45",X"4C",X"43",X"4F",X"4D",X"45",X"21",
	X"21",X"20",X"50",X"52",X"45",X"53",X"53",X"20",
-- Line 2----KEY 3 TO START
   X"4B",X"45",X"59",X"20",X"33",X"20",X"54",X"4F",
	X"20",X"53",X"54",X"41",X"52",X"54",X"20",X"20");
---------------------------------------------------------------------------------
elsif Input = "001" then
Output <= (
-- Line 1----PRESS KEY 3 TO 
   X"50",X"52",X"45",X"53",X"53",X"20",X"4B",X"45",
	X"59",X"20",X"33",X"20",X"54",X"4F",X"20",X"20",
-- Line 2----STOP
   X"53",X"54",X"4F",X"50",X"20",X"20",X"20",X"20",
	X"20",X"20",X"20",X"20",X"20",X"20",X"20",X"20");
---------------------------------------------------------------------------------
elsif Input = "010" then
Output <= (
-- Line 1-----YOU WIN!!
   X"59",X"4F",X"55",X"20",X"57",X"49",X"4E",X"21",
	X"21",X"20",X"20",X"20",X"20",X"20",X"20",X"20",
-- Line 2----
   X"20",X"20",X"20",X"20",X"20",X"20",X"20",X"20",
	X"20",X"20",X"20",X"20",X"20",X"20",X"20",X"20");
---------------------------------------------------------------------------------
elsif Input = "011" then
Output <= (
-- Line 1-----YOU LOSE!!
   X"59",X"4F",X"55",X"20",X"4C",X"4F",X"53",X"45",
	X"21",X"21",X"20",X"20",X"20",X"20",X"20",X"20",
-- Line 2-----
   X"20",X"20",X"20",X"20",X"20",X"20",X"20",X"20",
	X"20",X"20",X"20",X"20",X"20",X"20",X"20",X"20");
---------------------------------------------------------------------------------
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
package LCD_String_DataType is
	TYPE character_string IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 7 DOWNTO 0 );
end package;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

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
