library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
entity Binary_to_BCD is
port(Bin: in std_logic_vector (17 downto 0);
		BCDout: out std_logic_vector (19 downto 0));
end Binary_to_BCD;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
architecture Ckt of Binary_to_BCD is
begin

process(Bin)
variable B : std_logic_vector (17 downto 0);
variable BCD : std_logic_vector (19 downto 0);
begin

B := Bin;
BCD := (others => '0');

for i in 0 to 17 loop

if BCD(3 downto 0) > "0100" then
	BCD(3 downto 0) := BCD(3 downto 0) + "0011";
end if;

if BCD(7 downto 4) > "0100" then
	BCD(7 downto 4) := BCD(7 downto 4) + "0011";
end if;

if BCD(11 downto 8) > "0100" then
	BCD(11 downto 8) := BCD(11 downto 8) + "0011";
end if;

if BCD(15 downto 12) > "0100" then
	BCD(15 downto 12) := BCD(15 downto 12) + "0011";
end if;

if BCD(19 downto 16) > "0100" then
	BCD(19 downto 16) := BCD(19 downto 16) + "0011";
end if;

BCD := BCD(18 downto 0) & B(17);
B := B(16 downto 0) & '0';

end loop;

BCDout <= BCD;

end process;
end Ckt;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------