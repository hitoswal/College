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