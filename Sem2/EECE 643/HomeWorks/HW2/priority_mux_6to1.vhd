library IEEE;
use IEEE.Std_Logic_1164.all;

entity priority_mux_6to1 is
	generic (WIDTH: integer := 8);
	port(
		d0, d1, d2, d3, d4, d5: in std_logic_vector(WIDTH-1 downto 0);
		sel: in std_logic_vector(4 downto 0);
		d_out: out std_logic_vector(WIDTH-1 downto 0)
	);
end priority_mux_6to1;

architecture priority_mux_6to1 of priority_mux_6to1 is
	component mux_2to1 is
		generic (WIDTH : integer := 8);
		port (
			d1, d0: in std_logic_vector(WIDTH-1 downto 0);
			sel   : in std_logic;
			d_out : out std_logic_vector(WIDTH-1 downto 0)
		);
	end component;

	type d_temp_type is array(3 downto 0) of std_logic_vector(WIDTH-1 downto 0);
	signal d_temp: d_temp_type;
begin

	mux0: mux_2to1 generic map(WIDTH => WIDTH) port map(d1 => d1, d0 => d0,        sel => sel(0), d_out => d_temp(0));
	mux1: mux_2to1 generic map(WIDTH => WIDTH) port map(d1 => d2, d0 => d_temp(0), sel => sel(1), d_out => d_temp(1));
	mux2: mux_2to1 generic map(WIDTH => WIDTH) port map(d1 => d3, d0 => d_temp(1), sel => sel(2), d_out => d_temp(2));
	mux3: mux_2to1 generic map(WIDTH => WIDTH) port map(d1 => d4, d0 => d_temp(2), sel => sel(3), d_out => d_temp(3));
	mux4: mux_2to1 generic map(WIDTH => WIDTH) port map(d1 => d5, d0 => d_temp(3), sel => sel(4), d_out => d_out);

end priority_mux_6to1;
