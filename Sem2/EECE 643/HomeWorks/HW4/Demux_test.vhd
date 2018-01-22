--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Demux_test is
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
    Port ( AdderOut : in  signed (DATA_WIDTH-1 downto 0);
				sel3:		in	 integer range 0 to MATRIX_SIZE-1;
				clk: in STD_LOGIC;
           y_out : out  signed (MATRIX_SIZE*DATA_WIDTH-1 downto 0));
end Demux_test;

architecture Behavioral of Demux_test is
subtype data_value is signed(DATA_WIDTH-1 downto 0);
type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
signal y_val 		: 	data_vector:= (others => (others => '0'));
begin

	process (clk, AdderOut)
		begin
			if(clk'event and clk='1') then
				y_val(sel3)<=AdderOut;		
			end if;
	end process;
unpacking_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		y_out((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= y_val(i);
	end generate;
end Behavioral;

