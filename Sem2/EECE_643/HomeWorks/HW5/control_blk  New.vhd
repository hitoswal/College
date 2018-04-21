
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
           sel2 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1);
end control_blk;

architecture Behavioral of control_blk is

begin


	controller:process(clk)
		variable flag:std_logic;
		variable Count1 : Integer range 0 to 4 := 0;
	begin

		if(clk'event and clk='1') then	
			if(reset='0') then
				sel1<= Count1;	
				Count1 := Count1 + 1;
				if(Count1=5)then
					Count1:=0;
				end if;
			
				if(sel1=0)then
					sel2<=0;
				else
					sel2<=sel2+1;
				end if;
				
				if(sel1=4 and sel2=3) then
					done <= '1';
					ready <= '1';
				else
					done <= '0';
					ready <= '0';
				end if;
				
			else
				sel1 <= 0;
				sel2 <= 0;
				done <= '0';
				ready <= '1';
			end if;
			
			
		end if;

	
			
	end process;






end Behavioral;

