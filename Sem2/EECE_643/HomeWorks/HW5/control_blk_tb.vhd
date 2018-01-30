LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY control_blk_tb IS
GENERIC(MATRIX_SIZE:INTEGER :=5);
END control_blk_tb;
 
ARCHITECTURE behavior OF control_blk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_blk is
		  GENERIC(MATRIX_SIZE:INTEGER :=5);
		  Port ( clk : in  STD_LOGIC;
			 	   start : in  STD_LOGIC;
				   reset : in  STD_LOGIC;
				   done : out  STD_LOGIC;
				   ready:	out  STD_LOGIC;
				   sel1 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1;
				   sel2 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1
				   );
	 end COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal ready : std_logic;
   signal sel1 : INTEGER RANGE 0 TO MATRIX_SIZE-1;
   signal sel2 : INTEGER RANGE 0 TO MATRIX_SIZE-1;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_blk generic map (MATRIX_SIZE => MATRIX_SIZE)
			 PORT MAP (
          clk => clk,
          start => start,
          reset => reset,
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

      wait;
   end process;

END;
