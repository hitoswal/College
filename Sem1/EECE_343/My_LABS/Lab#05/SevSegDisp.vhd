library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
entity SevSegDisp is
port( DataIn: in std_logic_vector(3 downto 0);
		Segout: out std_logic_vector(6 downto 0));
end SevSegDisp;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
architecture ckt of sevSegDisp is
signal seg_Data : std_logic_vector(6 downto 0);
begin
process(DataIn)
begin
case DataIn is
	when "0000" => seg_Data <= "1111110"; --0
	when "0001" => seg_Data <= "0110000"; --1
	when "0010" => seg_Data <= "1101101"; --2
	when "0011" => seg_Data <= "1111001"; --3
	when "0100" => seg_Data <= "0110011"; --4
	when "0101" => seg_Data <= "1011011"; --5
	when "0110" => seg_Data <= "1011111"; --6
	when "0111" => seg_Data <= "1110000"; --7
	when "1000" => seg_Data <= "1111111"; --8
	when "1001" => seg_Data <= "1111011"; --9
	when "1010" => seg_Data <= "1110111"; --A
	when "1011" => seg_Data <= "1111111"; --B
	when "1100" => seg_Data <= "1001110"; --C
	when "1101" => seg_Data <= "1111110"; --D
	when "1110" => seg_Data <= "1001111"; --E
	when others => seg_Data <= "1000111"; --F
end case;

Segout(0) <= not seg_Data(6);
Segout(1) <= not seg_Data(5);
Segout(2) <= not seg_Data(4);
Segout(3) <= not seg_Data(3);
Segout(4) <= not seg_Data(2);
Segout(5) <= not seg_Data(1);
Segout(6) <= not seg_Data(0);

end process;
end ckt;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------