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
	 Port ( X0, X1, X2, X3, X4, X5 : in  STD_LOGIC;
           S0, S1, S2, S3, S4 : in  STD_LOGIC;
           O : out  STD_LOGIC);
end PriorityMux;

architecture Behavioral of PriorityMux is

COMPONENT Mun2to1
	PORT(
		a : IN std_logic;
		b : IN std_logic;
		s : IN std_logic;          
		o : OUT std_logic);
	END COMPONENT;
signal Temp : STD_LOGIC_VECTOR(3 downto 0);

begin

MUX1: Mun2to1 port map (X0, X1, S0, Temp(0)); 
MUX2: Mun2to1 port map (Temp(0), X2, S1, Temp(1));
MUX3: Mun2to1 port map (Temp(1), X3, S2, Temp(2));
MUX4: Mun2to1 port map (Temp(2), X4, S3, Temp(3));
MUX5: Mun2to1 port map (Temp(3), X5, S4, O);

end Behavioral;

