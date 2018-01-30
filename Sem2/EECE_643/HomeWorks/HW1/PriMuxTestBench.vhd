--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:17:43 02/03/2016
-- Design Name:   
-- Module Name:   F:/College/Sem2/EECE 643/HomeWorks/HW1/PriMuxTestBench.vhd
-- Project Name:  HW1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PriorityMux
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PriMuxTestBench IS
END PriMuxTestBench;
 
ARCHITECTURE behavior OF PriMuxTestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PriorityMux
    PORT(
         X0 : IN  std_logic;
         X1 : IN  std_logic;
         X2 : IN  std_logic;
         X3 : IN  std_logic;
         X4 : IN  std_logic;
         X5 : IN  std_logic;
         S0 : IN  std_logic;
         S1 : IN  std_logic;
         S2 : IN  std_logic;
         S3 : IN  std_logic;
         S4 : IN  std_logic;
         O : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal X0 : std_logic := '0';
   signal X1 : std_logic := '0';
   signal X2 : std_logic := '0';
   signal X3 : std_logic := '0';
   signal X4 : std_logic := '0';
   signal X5 : std_logic := '0';
   signal S0 : std_logic := '0';
   signal S1 : std_logic := '0';
   signal S2 : std_logic := '0';
   signal S3 : std_logic := '0';
   signal S4 : std_logic := '0';

 	--Outputs
   signal O : std_logic;
	signal Expected : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PriorityMux PORT MAP (
          X0 => X0,
          X1 => X1,
          X2 => X2,
          X3 => X3,
          X4 => X4,
          X5 => X5,
          S0 => S0,
          S1 => S1,
          S2 => S2,
          S3 => S3,
          S4 => S4,
          O => O
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

--      wait for <clock>_period*10;
      wait for 100 ns;	
		X1 <= not X1 after 100 ns;
		X2 <= not X2 after 200 ns;
		X3 <= not X3 after 300 ns;
		X4 <= not X4 after 400 ns;
		X5 <= not X5 after 500 ns;
		
		S0 <= not S0 after 500 ns;
		S1 <= not S1 after 500 ns;
		S2 <= not S2 after 500 ns;
		S3 <= not S3 after 500 ns;
		S4 <= not S4 after 500 ns;
		
		if (S4 = '1') then Expected <= X5;
		elsif (S3 = '1') then Expected <= X4;
		elsif (S2 = '1') then Expected <= X3;
		elsif (S1 = '1') then Expected <= X2;
		elsif (S0 = '1') then Expected <= X1;
		else Expected <= X0;
		end if;
      -- insert stimulus here 

      wait;
   end process;

END;
