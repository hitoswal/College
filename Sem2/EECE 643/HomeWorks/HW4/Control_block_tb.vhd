--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY Control_block_tb IS
END Control_block_tb;
 
ARCHITECTURE behavior OF Control_block_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
		constant MATRIX_SIZE : integer := 5;
    COMPONENT Control_block
   generic(MATRIX_SIZE : integer := 5);
	port	(
				clk	:	in std_logic;
				start	:	in std_logic;
				reset	:	in std_logic;
				read_data : out STD_LOGIC;
				Sel	:	out std_logic;
				Sel1	:	out integer range 0 to MATRIX_SIZE - 1;
				Sel2	:	out integer range 0 to MATRIX_SIZE - 1;
				Sel3	:	out integer range 0 to MATRIX_SIZE - 1;
				done	:	out std_logic;
				ready	:	out std_logic
			);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal Sel : std_logic;
	signal read_data : std_logic;
   signal Sel1 : integer range 0 to MATRIX_SIZE - 1;
   signal Sel2 : integer range 0 to MATRIX_SIZE - 1;
   signal Sel3 : integer range 0 to MATRIX_SIZE - 1;
   signal done : std_logic;
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control_block PORT MAP (
          clk => clk,
          start => start,
          reset => reset,
          read_data => read_data,
          Sel => Sel,
          Sel1 => Sel1,
          Sel2 => Sel2,
          Sel3 => Sel3,
          done => done,
          ready => ready
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

      reset <= '1';
		wait for clk_period*3;
		reset <= '0';
		wait for clk_period*3;
		start <= '1';
		wait for clk_period*3;
		start <= '0';
		wait for clk_period*50;
		start <= '1';
		wait for clk_period*3;
		start <= '0';
		wait for clk_period*50;

      wait;
   end process;

END;
