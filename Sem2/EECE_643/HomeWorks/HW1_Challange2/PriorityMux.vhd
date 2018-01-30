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
use work.Datatype.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PriorityMux is 
	 Generic ( N : Integer := 5;
				  M : Integer := 3);
    Port ( X : in  Inputsig (M downto 0)(N-1 downto 0);
           Sel : in  STD_LOGIC_VECTOR (M-1 downto 0);
           O : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PriorityMux;

architecture Behavioral of PriorityMux is

COMPONENT Mun2to1
	Generic ( Bi: Integer := 4);
	PORT(
		a : IN std_logic_vector(Bi-1 downto 0);
		b : IN std_logic_vector(Bi-1 downto 0);
		s : IN std_logic;          
		o : OUT std_logic_vector(Bi-1 downto 0)
		);
END COMPONENT;

signal Temp : Inputsig(M downto 0)(N-1 downto 0);

begin

Temp(0) <= X(0);
O <= Temp(M);

gen: for i in 0 to M-1 generate
	MUX: Mun2to1 generic map (N) port map (Temp(i), X(i+1), Sel(i), Temp(i+1));
end generate;

end Behavioral;

