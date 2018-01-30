
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Control_blk is
generic	(
				Elements		: integer	:=	5
			);
port	(
			clk	: 	in std_logic;
			start	: 	in std_logic;
			reset	:	in std_logic;
			Sel1	: 	out integer range 0 to Elements - 1;
			Sel2	: 	out integer range 0 to Elements - 1;
			Sel3	: 	out integer range 0 to Elements - 1;
			Sel	: 	out std_logic;
			ready : 	out std_logic;
			done	: 	out std_logic
		);
end Control_blk;

architecture Behavioral of Control_blk is

signal count_1 : integer range 0 to Elements - 1 := 0;
signal count_2 : integer range 0 to Elements - 1 := 0;
signal count_3 : integer range 0 to Elements - 1 := 0;
signal flag		: std_logic;

begin

	process (clk, start, reset)
	begin
		if (reset = '1') then
			count_1 <= 0;
			count_2 <= 0;
			count_3 <= 0;
			Sel <= '0';
			--flag <= '0';
		else
			if (clk'Event and clk = '1') then
				gen:
				
				if (count_1 = Elements - 1) then
					count_1 <= 0;
					Sel <= '0';
					if (count_2 = Elements - 1) then
						count_2 <= 0;
					else
						count_2 <= count_2 + 1;
					end if;
				else
					count_1 <= count_1 + 1;
					Sel <= '1';
				end if;
				
				if (count_1 = Elements - 1 and count_2 = Elements - 1)then
					ready <= '1';
					done <= '1';
				else
					done <=	'0';
				end if;
				
			end if;
		end if;
	end process;
	
	Sel1 <= count_1;
	Sel2 <= count_2;
	Sel3 <= count_3;
end Behavioral;

