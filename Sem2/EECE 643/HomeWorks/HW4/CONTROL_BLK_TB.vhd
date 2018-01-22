--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY CONTROL_BLK_TB IS
END CONTROL_BLK_TB;
 
ARCHITECTURE behavior OF CONTROL_BLK_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 constant MATRIX_SIZE : integer := 5;
    COMPONENT control_blk
        GENERIC(MATRIX_SIZE:INTEGER :=5);
	 Port ( clk : in  STD_LOGIC;
           start : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  done : out  STD_LOGIC;
           sel : out  STD_LOGIC;
           sel1 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1;
           sel2 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1;
           sel3 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal done : std_logic;
   signal sel : std_logic;
	signal sel1 : INTEGER RANGE 0 TO MATRIX_SIZE-1;
   signal sel2 : INTEGER RANGE 0 TO MATRIX_SIZE-1;
   signal sel3 : INTEGER RANGE 0 TO MATRIX_SIZE-1;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_blk PORT MAP (
          clk => clk,
          start => start,
          reset => reset,
			 done => done,
          sel => sel,
          sel1 => sel1,
          sel2 => sel2,
          sel3 => sel3
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
		reset <= '0';
		start <= '1'; 

 -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		reset <= '0';
		start <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
