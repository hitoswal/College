----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:42:38 01/28/2016 
-- Design Name: 
-- Module Name:    Mun2to1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mun2to1 is
    Generic ( N: Integer := 4);
	 Port ( a : in  STD_LOGIC_VECTOR(N-1 downto 0);
           b : in  STD_LOGIC_VECTOR(N-1 downto 0);
           s : in  STD_LOGIC;
           o : out  STD_LOGIC_VECTOR(N-1 downto 0));
end Mun2to1;

architecture Behavioral of Mun2to1 is

begin

o <= 	a when s = '0' else
		b when s = '1' else 
		(Others => 'Z');

end Behavioral;

