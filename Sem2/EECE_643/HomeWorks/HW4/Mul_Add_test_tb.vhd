LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Mul_Add_test_tb IS
END Mul_Add_test_tb;
 
ARCHITECTURE behavior OF Mul_Add_test_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	
	constant DATA_WIDTH : integer := 8;
	
	COMPONENT Mul_Add_test is
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port	(
				clk			:	in std_logic;
				Sel			:	in std_logic;
				Mul1			:	in signed (DATA_WIDTH-1 downto 0);
				Mul2			:	in signed (DATA_WIDTH-1 downto 0);
				ProductOut	:	buffer signed (2*DATA_WIDTH-1 downto 0);
				ProductIn	:	buffer signed (2*DATA_WIDTH-1 downto 0);
				AdderIn		:	buffer signed (2*DATA_WIDTH-1 downto 0);
				AddOut		:	buffer signed (2*DATA_WIDTH-1 downto 0);
				AdderOut		:	buffer signed (2*DATA_WIDTH-1 downto 0)
			);
	END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Sel : std_logic := '0';
   signal Mul1 : signed(DATA_WIDTH - 1 downto 0) := (others => '0');
   signal Mul2 : signed(DATA_WIDTH - 1 downto 0) := (others => '0');

 	--Outputs
   signal ProductOut : signed(2*DATA_WIDTH-1 downto 0);
   signal ProductIn : signed(2*DATA_WIDTH-1 downto 0);
   signal AdderIn : signed(2*DATA_WIDTH-1 downto 0);
   signal AddOut : signed(2*DATA_WIDTH-1 downto 0);
   signal AdderOut : signed(2*DATA_WIDTH-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Mul_Add_test generic map (DATA_WIDTH => DATA_WIDTH)
	PORT MAP (
          clk => clk,
          Sel => Sel,
          Mul1 => Mul1,
          Mul2 => Mul2,
          ProductOut => ProductOut,
          ProductIn => ProductIn,
          AdderIn => AdderIn,
          AddOut => AddOut,
          AdderOut => AdderOut
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

      Mul1 <= to_signed(1, DATA_WIDTH);
		Mul2 <= to_signed(2, DATA_WIDTH);
		Sel <= '0';
		
		wait for clk_period;
		
		Mul1 <= to_signed(2, DATA_WIDTH);
		Mul2 <= to_signed(3, DATA_WIDTH);
		Sel <= '1';
		
		wait for clk_period;
		
		Mul1 <= to_signed(3, DATA_WIDTH);
		Mul2 <= to_signed(4, DATA_WIDTH);
		Sel <= '0';
		
		wait for clk_period;
		
		Mul1 <= to_signed(4, DATA_WIDTH);
		Mul2 <= to_signed(5, DATA_WIDTH);
		Sel <= '1';

      wait;
   end process;

END;
