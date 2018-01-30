--------------------------------Home Work 5---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AdderBlk is
	generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port(
		Mult : in signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0);
		Addition : out signed(2*DATA_WIDTH-1 downto 0)
	);
end AdderBlk;

architecture Behavioral of AdderBlk is

	component adder is
		generic(DATA_WIDTH : integer :=32);
		port(
			a, b : in signed(2*DATA_WIDTH-1 downto 0);
			add : buffer signed(2*DATA_WIDTH-1 downto 0)
		);
	end component; 

	subtype data_value is signed(DATA_WIDTH-1 downto 0);
	subtype double_data_value is signed(2*DATA_WIDTH-1 downto 0);
	type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
	type double_data_vector is array(integer range MATRIX_SIZE-1 downto 0) of double_data_value;
	
	signal Mult_Vect 	: 	double_data_vector;
	signal Add_Wire	:	double_data_vector;
	
begin

	packing_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		Mult_Vect(i) <= Mult((i+1)*2*DATA_WIDTH-1 downto i*2*DATA_WIDTH);
	end generate packing_loop;
	
	Add_Wire(0) <= Mult_Vect(0);
	
	Add_loop:
	for i in 1 to MATRIX_SIZE - 1 generate
		Add:	
		adder generic map (DATA_WIDTH => DATA_WIDTH)
		port map (
						a => Mult_Vect(i),
						b => Add_Wire(i-1),
						add => Add_Wire(i)
					);
	end generate Add_loop;
	
	Addition <= Add_Wire (MATRIX_SIZE-1);

end Behavioral;

