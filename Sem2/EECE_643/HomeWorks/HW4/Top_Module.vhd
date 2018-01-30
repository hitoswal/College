--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------
-- Do not modify the module interface.
--
-- You may ignore the parameters if needed. Your submissions will not be
-- tested with values different from the defaults provided.
--
-- You may use the packing/upacking code provided or create your own
-- equivalent code.
--
-- Inputs:
-- x     - The vector of input values arranged {xM,...,x4,x3,x2,x1,x0}. These
--         may not remain stable during the computation (i.e., x may change
--         between the start and finish signals).
-- clk   - Input clock. Use the rising edge in your design.
-- start - Active high control signal that indicates the values provided on
--         x should be accepted for processing. The value of x should be saved
--         on the clock cycle in which both high and ready are asserted. start
--         should be ignored if ready is deasserted.
-- reset - Active high synchronous signal that causes sytem to be reset.
--
-- Outputs:
-- y     - The vector of output values arranged {yM,...,y4,y3,y2,y1,y0}. They
--         may take on any value while done is deasserted, but must have the
--         correct result whenever done is asserted.
-- ready - Active high control signal indicating the module is ready to accept
--         a new input. Ready should remain asserted whenever the module is
--         capable of accepting new input and should remain deasserted during
--         any period in which the module cannot accept new input. ready must
--         become active for at least one cycle between computations.
-- done  - Active high control signal indicating the computation is complete
--         and the result, y, is valid. done should remain asserted for only
--         one cycle.
--------------------------------------


entity hw4 is
	generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
	port (
		x     : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
		clk   : in std_logic;
		start : in std_logic;
		reset : in std_logic;
		y     : out signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
		ready : out std_logic;
		done  : out std_logic
	);
end hw4;

architecture Behavioral of hw4 is

	component DataEntry is
		generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		port	(
					clk   		: 	in std_logic;
					read_data	:	in std_logic;
					x     		: 	in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
					Sel1			: 	in integer range 0 to MATRIX_SIZE-1; 
					Sel2			: 	in integer range 0 to MATRIX_SIZE-1;
					aMul			: 	buffer signed(DATA_WIDTH-1 downto 0);
					xMul			: 	buffer signed(DATA_WIDTH-1 downto 0)
				);
	end component;
	
	component Mul_Add_test is
		generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		port	(
					clk			:	in std_logic;
					Sel			:	in std_logic;
					Mul1			:	in signed (DATA_WIDTH-1 downto 0);
					Mul2			:	in signed (DATA_WIDTH-1 downto 0);
					AddOut		:	buffer signed (DATA_WIDTH-1 downto 0)
				);
	end component;
	
	component Demux_test is
		generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		Port 
				( 
					AdderOut 	: 	in  signed (DATA_WIDTH-1 downto 0);
					sel3			:	in	 integer range 0 to MATRIX_SIZE-1;
					clk			: 	in STD_LOGIC;
					y_out 		: 	out  signed (MATRIX_SIZE*DATA_WIDTH-1 downto 0)
				);
	end component;
	
	component Control_block is
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
	end component;

signal read_data : std_logic;
signal ready_sig : std_logic;
signal Sel : std_logic;
signal Sel1 : integer range 0 to MATRIX_SIZE - 1;
signal Sel2 : integer range 0 to MATRIX_SIZE - 1;
signal Sel3 : integer range 0 to MATRIX_SIZE - 1;
signal aMul : signed (DATA_WIDTH - 1 downto 0);
signal xMul : signed (DATA_WIDTH - 1 downto 0);
signal AdderOut : signed (DATA_WIDTH-1 downto 0);

begin
	
	ready <= ready_sig;
--	read_data <= clk and ready_sig and start;

	DATA_ENTRY:
	DataEntry generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	port map	(
					clk => clk,
					read_data => read_data,
					x => x,
					Sel1 => Sel1,
					Sel2 => Sel2,
					aMul => aMul,
					xMul => xMul					
				);
				
	Calculations:
	Mul_Add_test generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	port map (
					clk => clk,
					Sel => Sel,
					Mul1 => aMul,
					Mul2 => xMul,
					AddOut => AdderOut
				);
	
	Output:
	Demux_test generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	port map (
					AdderOut => AdderOut,
					sel3 => Sel3,
					clk => clk,
					y_out => y
				);	
				
	control:
	Control_block generic map (MATRIX_SIZE => MATRIX_SIZE)
	port map (
					clk => clk,
					start => start,
					reset => reset,
					read_data => read_data,
					Sel => Sel,
					Sel1 => Sel1,
					Sel2 => Sel2,
					Sel3 => Sel3,
					done => done,
					ready => ready_sig
				);

end Behavioral;

