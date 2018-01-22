--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:49:24 02/03/2016
-- Design Name:   
-- Module Name:   F:/College/Sem2/EECE 643/HomeWorks/HW2/Priority_mux_6to1_tb.vhd
-- Project Name:  Homework2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: priority_mux_6to1
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
use IEEE.Math_Real.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_arith.all;
use IEEE.Std_Logic_Textio.all;
use STD.textio.all;
use STD.Env.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Priority_mux_6to1_tb IS
END Priority_mux_6to1_tb;
 
ARCHITECTURE behavior OF Priority_mux_6to1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 
    COMPONENT priority_mux_6to1
    generic (WIDTH: integer := 8);
	 PORT(
         d0 : IN  std_logic_vector(WIDTH-1 downto 0);
         d1 : IN  std_logic_vector(WIDTH-1 downto 0);
         d2 : IN  std_logic_vector(WIDTH-1 downto 0);
         d3 : IN  std_logic_vector(WIDTH-1 downto 0);
         d4 : IN  std_logic_vector(WIDTH-1 downto 0);
         d5 : IN  std_logic_vector(WIDTH-1 downto 0);
         sel : IN  std_logic_vector(4 downto 0);
         d_out : OUT  std_logic_vector(WIDTH-1 downto 0)
        );
    END COMPONENT;
    
	constant WIDTH : Integer := 8;
   --Inputs
   signal d0 : std_logic_vector(WIDTH-1 downto 0):= (others => '0');
	signal d1 : std_logic_vector(WIDTH-1 downto 0):= (others => '0');
   signal d2 : std_logic_vector(WIDTH-1 downto 0):= (others => '0');
   signal d3 : std_logic_vector(WIDTH-1 downto 0):= (others => '0');
   signal d4 : std_logic_vector(WIDTH-1 downto 0):= (others => '0');
   signal d5 : std_logic_vector(WIDTH-1 downto 0):= (others => '0');
   signal sel : std_logic_vector(4 downto 0):= (others => '0');

 	--Outputs
   signal d_out : std_logic_vector(WIDTH-1 downto 0);
	signal error_count : integer := 0;
   --signal Expected : std_logic_vector(WIDTH-1 downto 0);
 
	--Procedure Declaration	  
	procedure Test (
		Selin : in std_logic_vector(4 downto 0);
		signal Sel : out std_logic_vector(4 downto 0);
		signal Xin1 : inout std_logic_vector(WIDTH-1 downto 0);
		signal Xin2 : inout std_logic_vector(WIDTH-1 downto 0);
		signal Xin3 : inout std_logic_vector(WIDTH-1 downto 0);
		signal Xin4 : inout std_logic_vector(WIDTH-1 downto 0);
		signal Xin5 : inout std_logic_vector(WIDTH-1 downto 0);
		signal Xin6 : inout std_logic_vector(WIDTH-1 downto 0);
		signal d_out : in std_logic_vector(WIDTH-1 downto 0);
		signal error_count : inout integer
		) is
		
		variable error : std_logic := '0';
		variable input : std_logic_vector(WIDTH-1 downto 0);
		variable rand : Real;
		variable display : line;
		
		begin
		
		Sel <= Selin;
		
		Xin1 <= conv_std_logic_vector(25,WIDTH);
		Xin2 <= conv_std_logic_vector(20,WIDTH);
		Xin3 <= conv_std_logic_vector(15,WIDTH);
		Xin4 <= conv_std_logic_vector(10,WIDTH);
		Xin5 <= conv_std_logic_vector(1,WIDTH);
		Xin6 <= conv_std_logic_vector(5,WIDTH);
				
		wait for 10 ns;
		
		if (Selin(4) = '1') then 
			if (d_out = Xin6) then
				error := '0';
				write(display, "[T=" & time'image(now) & "] correct output. Test Success for Selectline ");
				write(display, Selin);
				writeline(output, display);
			else 
				error := '1';
				write(display, "[T=" & time'image(now) & "] incorrect output. Expected ");
				write(display, Xin6);
				write(display, ", with Selectline ");
				write(display, Selin);
				write(display, ", got ");
				write(display, d_out);
				write(display, ".");
				writeline(output, display);
			end if;
		elsif (Selin(3) = '1') then
			if (d_out = Xin5) then
				error := '0';
				write(display, "[T=" & time'image(now) & "] correct output. Test Success for Selectline ");
				write(display, Selin);
				writeline(output, display);
			else 
				error := '1';
				write(display, "[T=" & time'image(now) & "] incorrect output. Expected ");
				write(display, Xin5);
				write(display, ", with Selectline ");
				write(display, Selin);
				write(display, ", got ");
				write(display, d_out);
				write(display, ".");
				writeline(output, display);
			end if;
		elsif (Selin(2) = '1') then
			if (d_out = Xin4) then
				error := '0';
				write(display, "[T=" & time'image(now) & "] correct output. Test Success for Selectline ");
				write(display, Selin);
				writeline(output, display);
			else 
				error := '1';
				write(display, "[T=" & time'image(now) & "] incorrect output. Expected ");
				write(display, Xin4);
				write(display, ", with Selectline ");
				write(display, Selin);
				write(display, ", got ");
				write(display, d_out);
				write(display, ".");
				writeline(output, display);
			end if;
		elsif (Selin(1) = '1') then
			if (d_out = Xin3) then
				error := '0';
				write(display, "[T=" & time'image(now) & "] correct output. Test Success for Selectline ");
				write(display, Selin);
				writeline(output, display);
			else 
				error := '1';
				write(display, "[T=" & time'image(now) & "] incorrect output. Expected ");
				write(display, Xin3);
				write(display, ", with Selectline ");
				write(display, Selin);
				write(display, ", got ");
				write(display, d_out);
				write(display, ".");
				writeline(output, display);
			end if;
		elsif (Selin(0) = '1') then 
			if (d_out = Xin2) then
				error := '0';
				write(display, "[T=" & time'image(now) & "] correct output. Test Success for Selectline ");
				write(display, Selin);
				writeline(output, display);
			else 
				error := '1';
				write(display, "[T=" & time'image(now) & "] incorrect output. Expected ");
				write(display, Xin2);
				write(display, ", with Selectline ");
				write(display, Selin);
				write(display, ", got ");
				write(display, d_out);
				write(display, ".");
				writeline(output, display);
			end if;
		elsif (Selin(0) = '0') then 
			if (d_out = Xin1) then
				error := '0';
				write(display, "[T=" & time'image(now) & "] correct output. Test Success for Selectline ");
				write(display, Selin);
				writeline(output, display);
			else 
				error := '1';
				write(display, "[T=" & time'image(now) & "] incorrect output. Expected ");
				write(display, Xin1);
				write(display, ", with Selectline ");
				write(display, Selin);
				write(display, ", got ");
				write(display, d_out);
				write(display, ".");
				writeline(output, display);
			end if;
		end if;
		
		if (error = '1') then
			error_count <= error_count + 1; 
		end if;
		wait for 10 ns;
	end procedure;
			
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: priority_mux_6to1 
	generic map (WIDTH => WIDTH)
	PORT MAP (
          d0 => d0,
          d1 => d1,
          d2 => d2,
          d3 => d3,
          d4 => d4,
          d5 => d5,
          sel => sel,
          d_out => d_out
        );
		  
   -- Stimulus process
   stim_proc: process
   begin		
      	
		write(output, "**************************************" & LF);
		write(output, "** Starting simulation" & LF);
		write(output, "**************************************" & LF);
		-- hold reset state for 100 ns.
      wait for 100 ns;
		
		--Test
		Test("10110", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("11111", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("01110", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("01111", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("00100", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("00111", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("00010", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("00011", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("00001", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
		Test("00000", sel, d0, d1, d2, d3, d4, d5, d_out, error_count);
				
		
		write(output, "[T=" & time'image(now) & "] Simulation complete" & LF);
		write(output, "**************************************" & LF);
		write(output, "** " & integer'image(error_count) & " total errors" & LF);
		write(output, "**************************************" & LF);
		finish(0);
		--wait;
		end process;

END;
