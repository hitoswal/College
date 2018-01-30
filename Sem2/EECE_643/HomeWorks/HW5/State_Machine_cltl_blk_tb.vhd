--------------------------------Home Work 5---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY State_Machine_cltl_blk_tb IS
generic(MATRIX_SIZE : integer := 5);
END State_Machine_cltl_blk_tb;
 
ARCHITECTURE behavior OF State_Machine_cltl_blk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Control_block_SM is
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
   signal read_data : std_logic;
   signal Sel1 : integer range 0 to MATRIX_SIZE - 1;
   signal Sel2 : integer range 0 to MATRIX_SIZE - 1;
   signal done : std_logic;
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control_block_SM PORT MAP (
          clk => clk,
          start => start,
          reset => reset,
          read_data => read_data,
          Sel1 => Sel1,
          Sel2 => Sel2,
          done => done,
          ready => ready
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
		wait for clk_period*10;
		reset <= '0';
		start <= '1';
		wait for clk_period;
		start <= '0';
		wait for clk_period*10;
		start <= '1';
		wait for clk_period*10;
		start <= '0';
      wait;
   end process;

END;
