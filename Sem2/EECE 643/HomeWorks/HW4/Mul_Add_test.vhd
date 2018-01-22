--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mul_Add_test is
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port	(
				clk			:	in std_logic;
				Sel			:	in std_logic;
				Mul1			:	in signed (DATA_WIDTH-1 downto 0);
				Mul2			:	in signed (DATA_WIDTH-1 downto 0);
				AddOut		:	buffer signed (DATA_WIDTH-1 downto 0)
			);
end Mul_Add_test;

architecture Behavioral of Mul_Add_test is

	component multiplier is
		generic(DATA_WIDTH : integer :=32);
		port(
			a, b : in signed(DATA_WIDTH-1 downto 0);
			p : out signed(DATA_WIDTH-1 downto 0)
		);
	end component;
	
	component adder is
	generic(DATA_WIDTH : integer :=32);
	port(
		a, b : in signed(DATA_WIDTH-1 downto 0);
		add : buffer signed(DATA_WIDTH-1 downto 0)
	);
	end component;
	
	signal ProductOut	:	signed (DATA_WIDTH-1 downto 0);
	signal ProductIn	:	signed (DATA_WIDTH-1 downto 0);
	signal AdderIn		:	signed (DATA_WIDTH-1 downto 0);
	signal AdderOut	:	signed (DATA_WIDTH-1 downto 0);
	
begin


	Sequential_part:
	process(clk, AdderOut, ProductOut)
	begin
		if (clk'Event and clk = '1') then
			ProductIn <= ProductOut;
			AdderIn <= AdderOut;
		end if;
	end process Sequential_part;

	MUL:
	multiplier generic map(DATA_WIDTH => DATA_WIDTH)
	port map	(
					a => Mul1,
					b => Mul2,
					p => ProductOut
				);
	
	ADD:
	adder generic map(DATA_WIDTH => DATA_WIDTH)
	port map	(
					a => ProductIn,
					b => AdderIn,
					add => AddOut
				);
				
	AdderOut <= AddOut when (Sel = '1') else (others => '0');

end Behavioral;

