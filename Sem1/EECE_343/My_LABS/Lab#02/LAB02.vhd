------------------LAB#02--------------------
-----------Seven Segment Display------------
--------------------By----------------------
------------Hitesh Vijay Oswal--------------
---------------Omkar Sali-------------------
library ieee;
use ieee.std_logic_1164.all;

entity LAB02 is
port(sw : in std_logic_vector(0 to 2);
		leds: out std_logic_vector(0 to 2);
	  output: out std_logic_vector(6 downto 0));
end LAB02;

architecture ckt of LAB02 is
begin
leds <= sw;
output(0) <= not(((not(sw(0))) and sw(2)) or (sw(0) and (not(sw(1)))));
output(1) <= (sw(0) xnor sw(1)) xnor sw(2);
output(2) <= (sw(0) xnor sw(1)) xnor sw(2);
output(3) <= not(((not(sw(1))) and (sw(0) or sw(2))) or ((not(sw(0))) and sw(1)));
output(4) <= not((not(sw(0))) or ((not(sw(1))) and (not(sw(2)))));
output(5) <= not((not(sw(0))) or (sw(0) and (not(sw(2)))));
output(6) <= not(((not(sw(1))) and ((not(sw(0))) or sw(2))) or ((sw(0) and sw(1)) and (not((sw(2))))));
end ckt;