library IEEE;
use IEEE.Numeric_Std.all;

entity adder is
	generic(DATA_WIDTH : integer :=32);
	port(
		a, b : in signed(2*DATA_WIDTH-1 downto 0);
		add : out signed(2*DATA_WIDTH-1 downto 0)
	);
end adder;

architecture behavioral of adder is
begin
	add <= a + b;
end behavioral;
