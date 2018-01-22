--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.Numeric_Std.all;

entity adder is
	generic(DATA_WIDTH : integer :=32);
	port(
		a, b : in signed(DATA_WIDTH-1 downto 0);
		add : buffer signed(DATA_WIDTH-1 downto 0)
	);
end adder;

architecture behavioral of adder is
begin
	add <= a + b;
end behavioral;
