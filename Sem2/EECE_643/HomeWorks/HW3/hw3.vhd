--------------------------------Home Work 3---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
library IEEE;
use IEEE.NUMERIC_STD.ALL;

entity hw3 is
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port (
		x: in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
		y: out signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0)
	);
end hw3;

architecture behavioral of hw3 is
	
	-- Instantiate Multiplier
	component multiplier is
		generic(DATA_WIDTH : integer :=32);
		port(
			a, b : in signed(DATA_WIDTH-1 downto 0);
			p : out signed(2*DATA_WIDTH-1 downto 0)
		);
	end component;
	
	-- Instantiate Adder
	component adder is
	generic(DATA_WIDTH : integer :=32);
	port(
		a, b : in signed(2*DATA_WIDTH-1 downto 0);
		add : out signed(2*DATA_WIDTH-1 downto 0)
	);
	end component;

	subtype data_value is signed(DATA_WIDTH-1 downto 0);
	subtype double_data_value is signed(2*DATA_WIDTH-1 downto 0);
	type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
	type double_data_vector is array(integer range MATRIX_SIZE-1 downto 0) of double_data_value;
	
	type const_mat is array(integer range MATRIX_SIZE-1 downto 0, integer range MATRIX_SIZE-1 downto 0) of integer;
	type double_data_array is array(integer range MATRIX_SIZE-1 downto 0) of double_data_vector;
	
	signal x_val : data_vector; -- x_val(MATRIX_SIZE-1) down to x_val(0) are the DATA_WIDTH-bit values
	signal y_val : double_data_vector; -- Resulting y values
	signal temp : double_data_array;
	signal addition : double_data_array;
	
	-- Function to calculate Constant matrix
	function const return const_mat is
	
	variable a_val : const_mat;
	
	begin
	
		ConstMati_gen:	
		for i in MATRIX_SIZE-1 downto 0 loop
			ConstMatj_gen:
			for j in MATRIX_SIZE-1 downto 0 loop
				a_val(i,j) := (((-1)**(i+j))*(i+1)*(j+1));
			end loop ConstMatj_gen;
		end loop ConstMati_gen;
		return a_val;
	end function;
	
	-- Declaring constant matrix
	constant a_val : const_mat := const;
	
begin

	-- Pack output y and unpack input x
	packing_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		x_val(i) <= x((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
		y((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= y_val(i)(DATA_WIDTH-1 downto 0);
	end generate packing_loop;

	-- Obtaining Output Matrix
	array_loop:
	for j in MATRIX_SIZE-1 downto 0 generate
		
		-- Multiplying Inputs with constant matrix
		multi_loop:
		for i in MATRIX_SIZE-1 downto 0 generate
			mul:	multiplier generic map (DATA_WIDTH => DATA_WIDTH) 
					port map (
					a => to_signed(a_val(j,i), DATA_WIDTH), 
					b => x_val(i), 
					p => temp(j)(i)
					);
		end generate multi_loop;

		addition (j)(0)<=temp(j)(0);
		
		-- Addition of All Products
		add_loop:
		for i in 1 to MATRIX_SIZE-1 generate
			add:	adder generic map (DATA_WIDTH => DATA_WIDTH) 
					port map (
					a => addition(j)(i-1), 
					b => temp(j)(i), 
					add => addition(j)(i)
					);
		end generate add_loop;
		
		y_val(j) <= addition(j)(MATRIX_SIZE-1);
		
	end generate array_loop;

end behavioral;
