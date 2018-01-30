----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:01:33 01/29/2016 
-- Design Name: 
-- Module Name:    PriorityMux - Behavioral 
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

entity PriorityMux is 
	 Generic ( N : Integer := 5);
    Port ( X0, X1, X2, X3, X4, X5 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in  STD_LOGIC_VECTOR (4 downto 0);
           O : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PriorityMux;

architecture Behavioral of PriorityMux is

COMPONENT Mun2to1
	Generic ( N: Integer := 4);
	PORT(
		a : IN std_logic_vector(N-1 downto 0);
		b : IN std_logic_vector(N-1 downto 0);
		s : IN std_logic;          
		o : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;
Type Sig is array (3 downto 0) of STD_LOGIC_VECTOR (N-1 downto 0);
signal Temp : Sig;

begin

MUX1: Mun2to1 Generic map (N => N) port map (X0, X1, Sel(0), Temp(0)); 
MUX2: Mun2to1 Generic map (N => N) port map (Temp(0), X2, Sel(1), Temp(1));
MUX3: Mun2to1 Generic map (N => N) port map (Temp(1), X3, Sel(2), Temp(2));
MUX4: Mun2to1 Generic map (N => N) port map (Temp(2), X4, Sel(3), Temp(3));
MUX5: Mun2to1 Generic map (N => N) port map (Temp(3), X5, Sel(4), O);

end Behavioral;

