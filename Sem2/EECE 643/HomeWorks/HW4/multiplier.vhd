--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.Numeric_Std.all;

entity multiplier is
	generic(DATA_WIDTH : integer :=32);
	port(
		a, b : in signed(DATA_WIDTH-1 downto 0);
		p : out signed(DATA_WIDTH-1 downto 0)
	);
end multiplier;

architecture behavioral of multiplier is
signal Product : signed(2*DATA_WIDTH-1 downto 0);
begin
	Product <= a * b;
	p <= Product(DATA_WIDTH-1 downto 0);
end behavioral;
