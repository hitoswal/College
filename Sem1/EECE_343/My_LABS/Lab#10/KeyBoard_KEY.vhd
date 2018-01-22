library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity keyboard_KEY is
port( keyboard_clk, keyboard_data, clock_25mhz ,reset, read	:in std_logic;
		scan_code	:	out std_logic_vector(7 downto 0);
		scan_ready 	: out std_logic);
end keyboard_KEY;

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
