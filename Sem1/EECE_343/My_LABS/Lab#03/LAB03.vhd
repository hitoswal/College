----------------------------------------LAB#03------------------------------------
------------------------8-Bit Adder  and Seven Segment Display--------------------
------------------------------------------BY--------------------------------------
-----------------------------------Hitesh Vijay Oswal-----------------------------
------------------------------------------&---------------------------------------
-------------------------------------Omkar Sali-----------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity LAB03 is
port( x, y: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		ledx, ledy: out std_logic_vector(7 downto 0);
		ledc: out std_logic;
		seg1, seg2, seg3: out std_logic_vector(6 downto 0));
end LAB03;

architecture struct of LAB03 is

signal s: std_logic_vector(7 downto 0);
signal Cout: std_logic; 
signal m0, m1, m2: std_logic_vector(3 downto 0);
signal seg_data0, seg_data1, seg_data2: std_logic_vector(6 downto 0);
signal g: std_logic_vector(6 downto 0);

component fulladder is
port(Cin, x, y: in std_logic;
		S, Cout: out std_logic);
end component;

begin
stage1: fulladder port map (Cin, x(0), y(0), s(0), g(0));
stage2: fulladder port map (g(0), x(1), y(1), s(1), g(1));
stage3: fulladder port map (g(1), x(2), y(2), s(2), g(2));
stage4: fulladder port map (g(2), x(3), y(3), s(3), g(3));
stage5: fulladder port map (g(3), x(4), y(4), s(4), g(4));
stage6: fulladder port map (g(4), x(5), y(5), s(5), g(5));
stage7: fulladder port map (g(5), x(6), y(6), s(6), g(6));
stage8: fulladder port map (g(6), x(7), y(7), s(7), Cout);

m2 <= "000" & Cout;
m1 <= s(7) & s(6) & s(5) & s(4);
m0 <= s(3) & s(2) & s(1) & s(0);

process(m2, m1, m0)
begin

ledx <= x;
ledy <= y;
ledc <= Cin;

case m2 is
when "0001" => seg_data2 <= "0110000";
when others => seg_data2 <= "1111110";
end case;

case m1 is
when "0000" => seg_data1 <= "1111110";	--0
when "0001" => seg_data1 <= "0110000";	--1
when "0010" => seg_data1 <= "1101101";	--2
when "0011" => seg_data1 <= "1111001";	--3
when "0100" => seg_data1 <= "0110011";	--4
when "0101" => seg_data1 <= "1011011";	--5
when "0110" => seg_data1 <= "1011111";	--6
when "0111" => seg_data1 <= "1110000";	--7
when "1000" => seg_data1 <= "1111111";	--8
when "1001" => seg_data1 <= "1111011";	--9
when "1010" => seg_data1 <= "1110111";	--A
when "1011" => seg_data1 <= "1111111";	--B
when "1100" => seg_data1 <= "1001110";	--C
when "1101" => seg_data1 <= "1111110";	--D
when "1110" => seg_data1 <= "1001111";	--E
when "1111" => seg_data1 <= "1000111";	--F
end case;

case m0 is
when "0000" => seg_data0 <= "1111110";	--0
when "0001" => seg_data0 <= "0110000";	--1
when "0010" => seg_data0 <= "1101101";	--2
when "0011" => seg_data0 <= "1111001";	--3
when "0100" => seg_data0 <= "0110011";	--4
when "0101" => seg_data0 <= "1011011";	--5
when "0110" => seg_data0 <= "1011111";	--6
when "0111" => seg_data0 <= "1110000";	--7
when "1000" => seg_data0 <= "1111111";	--8
when "1001" => seg_data0 <= "1111011";	--9
when "1010" => seg_data0 <= "1110111";	--A
when "1011" => seg_data0 <= "1111111";	--B
when "1100" => seg_data0 <= "1001110";	--C
when "1101" => seg_data0 <= "1111110";	--D
when "1110" => seg_data0 <= "1001111";	--E
when "1111" => seg_data0 <= "1000111";	--F
end case;
end process;

seg3(0) <= not seg_data0(6);
seg3(1) <= not seg_data0(5);
seg3(2) <= not seg_data0(4);
seg3(3) <= not seg_data0(3);
seg3(4) <= not seg_data0(2);
seg3(5) <= not seg_data0(1);
seg3(6) <= not seg_data0(0);

seg2(0) <= not seg_data1(6);
seg2(1) <= not seg_data1(5);
seg2(2) <= not seg_data1(4);
seg2(3) <= not seg_data1(3);
seg2(4) <= not seg_data1(2);
seg2(5) <= not seg_data1(1);
seg2(6) <= not seg_data1(0);

seg1(0) <= not seg_data2(6);
seg1(1) <= not seg_data2(5);
seg1(2) <= not seg_data2(4);
seg1(3) <= not seg_data2(3);
seg1(4) <= not seg_data2(2);
seg1(5) <= not seg_data2(1);
seg1(6) <= not seg_data2(0);

end struct;


library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
port(Cin, x, y: in std_logic;
		S, Cout: out std_logic);
end fulladder;

architecture ckt of fulladder is
begin
S <= ((x xor y) xor Cin);
Cout <= (((x and y) or (y and Cin)) or (x and Cin));
end ckt;