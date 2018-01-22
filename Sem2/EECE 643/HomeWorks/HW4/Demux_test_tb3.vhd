LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
 
ENTITY Demux_test_tb3 IS
END Demux_test_tb3;
 
ARCHITECTURE behavior OF Demux_test_tb3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 constant DATA_WIDTH : integer :=8;
 constant MATRIX_SIZE : integer := 5;
    COMPONENT Demux_test
    generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
    Port ( AdderOut : in  signed (2*DATA_WIDTH-1 downto 0);
				sel3:		in	 integer range 0 to MATRIX_SIZE-1;
				clk: in STD_LOGIC;
           y_out : out  signed (MATRIX_SIZE*DATA_WIDTH-1 downto 0));
    END COMPONENT;
    

   --Inputs
   signal AdderOut :   signed (2*DATA_WIDTH-1 downto 0) := (others => '0');
   signal sel3 : 	 integer range 0 to MATRIX_SIZE-1 := 0;
   signal clk : std_logic := '0';

 	--Outputs
   signal y_out :   signed (MATRIX_SIZE*DATA_WIDTH-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Demux_test generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	PORT MAP (
          AdderOut => AdderOut,
          sel3 => sel3,
          clk => clk,
          y_out => y_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      AdderOut <= to_signed(10, 2*DATA_WIDTH);
		sel3	<= 0;
		wait for clk_period;
		
		AdderOut <= to_signed(20, 2*DATA_WIDTH);
		sel3	<= 1;
		wait for clk_period;
		
		AdderOut <= to_signed(30, 2*DATA_WIDTH);
		sel3	<= 2;
		wait for clk_period;
		
		AdderOut <= to_signed(40, 2*DATA_WIDTH);
		sel3	<= 3;
		wait for clk_period;
		
		AdderOut <= to_signed(50, 2*DATA_WIDTH);
		sel3	<= 4;
		wait for clk_period; 

      wait;
   end process;

END;
