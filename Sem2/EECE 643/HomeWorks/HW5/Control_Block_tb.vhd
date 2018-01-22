LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY control_blk_tb IS
GENERIC(MATRIX_SIZE:INTEGER :=5);
END control_blk_tb;
 
ARCHITECTURE behavior OF control_blk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Control_block is
		 generic(MATRIX_SIZE : integer := 5);
		 port	(
					 clk	:	in std_logic;
					 start	:	in std_logic;
					 reset	:	in std_logic;
					 read_data : out STD_LOGIC;
					 Sel1	:	out integer range 0 to MATRIX_SIZE - 1;
					 Sel2	:	out integer range 0 to MATRIX_SIZE - 1;
					 done	:	out std_logic;
					 ready	:	out std_logic
				);
	 end COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal ready : std_logic;
	signal read_data : std_logic;
   signal sel1 : INTEGER RANGE 0 TO MATRIX_SIZE-1;
   signal sel2 : INTEGER RANGE 0 TO MATRIX_SIZE-1;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control_block generic map (MATRIX_SIZE => MATRIX_SIZE)
			 PORT MAP (
          clk => clk,
          start => start,
          reset => reset,
			 read_data => read_data,
          done => done,
          ready => ready,
          sel1 => sel1,
          sel2 => sel2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
      wait for clk_period*10;
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		start <= '1';
		wait for clk_period;
      start <= '0';
		wait for clk_period*6;
		start <= '1';
		wait for clk_period;
      start <= '0';
		wait for clk_period*5;
		start <= '1';
		wait for clk_period;
      start <= '0';
      wait;
   end process;

END;
