---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
package LCD_String_DataType is
	TYPE character_string IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 7 DOWNTO 0 );
end package;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------