--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_blk is
    GENERIC(MATRIX_SIZE:INTEGER :=5);
	 Port ( clk : in  STD_LOGIC;
           start : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           done : out  STD_LOGIC;
			  ready:	out  STD_LOGIC;
           sel1 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1;
           sel2 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1
           );
end control_blk;

architecture Behavioral of control_blk is

begin


	controller:process(clk, reset)
	begin
		if (reset = '1') then
			sel1 <= 0;
				sel2 <= 0;
				done <= '0';
				ready <= '1';
				
		elsif(clk'event and clk='1') then	
			
--			if (sel2 = MATRIX_SIZE-1) then
--				done <= '1';
--				ready <= '1';
--			end if;
			
			if(sel1 = MATRIX_SIZE-1) then
				sel1<= 0;
				sel2<= MATRIX_SIZE-1;
				done <= '1';
				ready <= '1';
			else
				sel1 <= sel1+1;
				if(sel2 = MATRIX_SIZE-1)then
					sel2 <= 0;
				else
					sel2 <= sel1;
					done <= '0';
				end if;
			end if;
			
			
			
		end if;
	end process;
end Behavioral;

