--------------------------------Home Work 5---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multblk is
	generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port(
		x : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
		a : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
		Mult : out signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0)
	);
end Multblk;

architecture Behavioral of Multblk is
	
	component multiplier is
		generic(DATA_WIDTH : integer :=32);
		port(
			a, b : in signed(DATA_WIDTH-1 downto 0);
			p : out signed(2*DATA_WIDTH-1 downto 0)
		);
	end component;
	
	subtype data_value is signed(DATA_WIDTH-1 downto 0);
	subtype double_data_value is signed(2*DATA_WIDTH-1 downto 0);
	type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
	type double_data_vector is array(integer range MATRIX_SIZE-1 downto 0) of double_data_value;
	
	signal x_val : data_vector;
	signal a_val : data_vector;
	signal Mult_val : double_data_vector;
	
begin
	
	packing_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		x_val(i) <= x((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
		a_val(i) <= a((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
		Mult((i+1)*2*DATA_WIDTH-1 downto i*2*DATA_WIDTH) <= Mult_val(i)(2*DATA_WIDTH-1 downto 0);
	end generate packing_loop;
	
	Mult_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		mult:
		multiplier generic map (DATA_WIDTH => DATA_WIDTH)
		port map (
						a => x_val(i),
						b => a_val(i),
						P => Mult_val(i)
					);
	end generate Mult_loop;


end Behavioral;

