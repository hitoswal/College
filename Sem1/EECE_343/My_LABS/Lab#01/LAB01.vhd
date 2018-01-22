------------------------LAB#01---------------------------
--------To Interface Switch with LEDs using VHDL---------
---------------------------BY----------------------------
------------------Hitesh Vijay Oswal---------------------
----------------------Omkar Sali-------------------------
library ieee;
use ieee.std_logic_1164.all;
entity LAB01 is
port (SW : in bit_vector(17 downto 0);
		LED : out bit_vector(17 downto 0));
end LAB01;
architecture ckt of LAB01 is
begin
LED <= SW;
end ckt;