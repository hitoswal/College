--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
ENTITY DataEntry_tb IS
END DataEntry_tb;
 
ARCHITECTURE behavior OF DataEntry_tb IS 
 
	-- Component Declaration for the Unit Under Test (UUT)
	constant DATA_WIDTH 	: 	integer 	:= 	8;
	constant MATRIX_SIZE	:	integer	:= 	5;
	
	COMPONENT DataEntry
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port	(
				clk   		: 	in std_logic;
--				read_data 	:	in std_logic;
				x     		: 	in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
				Sel1			: 	in integer range 0 to MATRIX_SIZE-1; 
				Sel2			: 	in integer range 0 to MATRIX_SIZE-1;
				aMul			: 	buffer signed(DATA_WIDTH-1 downto 0);
				xMul			: 	buffer signed(DATA_WIDTH-1 downto 0)
			);
	END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal x : signed(MATRIX_SIZE*DATA_WIDTH - 1 downto 0) := (others => '0');
   signal Sel1 : integer range 0 to MATRIX_SIZE-1 := 0;
   signal Sel2 : integer range 0 to MATRIX_SIZE-1 := 0;

 	--Outputs
   signal aMul : signed(DATA_WIDTH - 1 downto 0);
   signal xMul : signed(DATA_WIDTH - 1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DataEntry generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
		PORT MAP (
          clk => clk,
          x => x,
          Sel1 => Sel1,
          Sel2 => Sel2,
          aMul => aMul,
          xMul => xMul
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

      x <= (to_signed(50,DATA_WIDTH) & to_signed(40,DATA_WIDTH) & to_signed(30,DATA_WIDTH) & to_signed(20,DATA_WIDTH) & to_signed(10,DATA_WIDTH));
		wait for clk_period;
		Sel1 <= 0;
		Sel2 <= 0;
		wait for clk_period;
		
		Sel1 <= 1;
		Sel2 <= 0;
		wait for clk_period;
		
		Sel1 <= 2;
		Sel2 <= 0;
		wait for clk_period;
		
		Sel1 <= 3;
		Sel2 <= 0;
		wait for clk_period;
		
		Sel1 <= 4;
		Sel2 <= 0;
		wait for clk_period;
		
		Sel1 <= 0;
		Sel2 <= 1;
		wait for clk_period;
		
		Sel1 <= 1;
		Sel2 <= 1;
		wait for clk_period;
		
		Sel1 <= 2;
		Sel2 <= 1;
		wait for clk_period;
		
		Sel1 <= 3;
		Sel2 <= 1;
		wait for clk_period;
		
		Sel1 <= 4;
		Sel2 <= 1;
		wait for clk_period;
		
		Sel1 <= 0;
		Sel2 <= 2;
		wait for clk_period;
		
		Sel1 <= 1;
		Sel2 <= 2;
		wait for clk_period;
		
		Sel1 <= 2;
		Sel2 <= 2;
		wait for clk_period;
		
		Sel1 <= 3;
		Sel2 <= 2;
		wait for clk_period;
		
		Sel1 <= 4;
		Sel2 <= 2;
		
      wait;
   end process;

END;
