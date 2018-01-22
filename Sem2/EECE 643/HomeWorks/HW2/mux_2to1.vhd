library IEEE;
use IEEE.Std_Logic_1164.all;

entity mux_2to1 is
	generic (WIDTH : integer := 8);
	port (
		d1, d0: in std_logic_vector(WIDTH-1 downto 0);
		sel   : in std_logic;
		d_out : out std_logic_vector(WIDTH-1 downto 0)
	);
end mux_2to1;

architecture mux_2to1 of mux_2to1 is 
begin
	process (d1, d0, sel) begin
		if( sel = '1' ) then
			d_out <= d1;
		else
			d_out <= d0;
		end if;
	end process;
end mux_2to1;
