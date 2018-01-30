--------------------------------Home Work 5---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use STD.textio.all;
use STD.Env.all;
 
ENTITY AdderBlk_tb IS
generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
END AdderBlk_tb;
 
ARCHITECTURE behavior OF AdderBlk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AdderBlk is
		 generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		 port(
			 Mult : in signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0);
		    Addition : out signed(2*DATA_WIDTH-1 downto 0)
		 );
	 end COMPONENT;
    
	subtype data_value is signed(DATA_WIDTH-1 downto 0);
	subtype double_data_value is signed(2*DATA_WIDTH-1 downto 0);
	type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
	type double_data_vector is array(integer range MATRIX_SIZE-1 downto 0) of double_data_value;

   --Inputs
   signal Mult : signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0) := (others => '0');

 	--Outputs
   signal Addition : signed(2*DATA_WIDTH-1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	
	--Signals
   signal Mult_val : double_data_vector;
	    
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AdderBlk generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
		  PORT MAP (
          Mult => Mult,
          Addition => Addition
        );
	
	packing_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		Mult((i+1)*2*DATA_WIDTH-1 downto i*2*DATA_WIDTH) <= Mult_val(i)(2*DATA_WIDTH-1 downto 0);
	end generate packing_loop;
   
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		add_loop:
		for i in MATRIX_SIZE downto 1 loop
			Mult_val <= (to_signed(i*5, 2*DATA_WIDTH),to_signed(i*4, 2*DATA_WIDTH),to_signed(i*3, 2*DATA_WIDTH),to_signed(i*2, 2*DATA_WIDTH),to_signed(i*1, 2*DATA_WIDTH));
			wait for 10 ns;	
		end loop add_loop;
		-- insert stimulus here 

      wait;
   end process;

END;
