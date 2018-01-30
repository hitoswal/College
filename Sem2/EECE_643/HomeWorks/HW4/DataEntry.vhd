--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataEntry is
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port	(
				clk   		: 	in std_logic;
				read_data	:	in std_logic;
				x     		: 	in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
				Sel1			: 	in integer range 0 to MATRIX_SIZE-1; 
				Sel2			: 	in integer range 0 to MATRIX_SIZE-1;
				aMul			: 	buffer signed(DATA_WIDTH-1 downto 0);
				xMul			: 	buffer signed(DATA_WIDTH-1 downto 0)
			);
end DataEntry;

architecture Behavioral of DataEntry is
	subtype data_value is signed(DATA_WIDTH-1 downto 0);
	type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
	type const_mat is array(integer range MATRIX_SIZE-1 downto 0) of data_vector;

	-- Function to calculate Constant matrix
	function const return const_mat is
	variable a_val : const_mat;
		begin
		ConstMati_gen:	
		for i in MATRIX_SIZE-1 downto 0 loop
			ConstMatj_gen:
			for j in MATRIX_SIZE-1 downto 0 loop
				a_val(i)(j) := to_signed((((-1)**(i+j))*(i+1)*(j+1)),DATA_WIDTH);
			end loop ConstMatj_gen;
		end loop ConstMati_gen;
		return a_val;
	end function;

	-- Declaring constant matrix
	constant a_val : 	const_mat 	:= const;
	signal x_val	:	data_vector;
	signal x_reg	:	data_vector;	
begin
	
	-- Pack output y and unpack input x
	
	unpacking_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		x_val(i) <= x((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
	end generate;
	
	process (read_data, x_val, clk)
	begin
		if(clk'Event and clk = '1')then
			if(read_data = '1')then
				x_reg <= x_val;
			end if;
		end if;
	end process;
	
	xMul <= x_reg(Sel1);
	aMul <= a_val(Sel2)(Sel1);


end Behavioral;

