--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

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

architecture behavioral of hw4 is
	
--	component Control_blk is
--		generic	(
--						Elements		: integer	:=	5
--					);
--		port	(
--					clk	: 	in std_logic;
--					start	: 	in std_logic;
--					reset	:	in std_logic;
--					Sel1	: 	out integer range 0 to Elements - 1;
--					Sel2	: 	out integer range 0 to Elements - 1;
--					Sel3	: 	out integer range 0 to Elements - 1;
--					Sel	: 	out std_logic;
--					ready : 	out std_logic;
--					done	: 	out std_logic
--				);
--		end component;
	
	component control_blk is
		 GENERIC(MATRIX_SIZE:INTEGER :=5);
		 Port ( clk : in  STD_LOGIC;
				  start : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  done : out  STD_LOGIC;
				  ready:	out  STD_LOGIC;
				  sel : out  STD_LOGIC;
				  sel1 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1;
				  sel2 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1;
				  sel3 : BUFFER  INTEGER RANGE 0 TO MATRIX_SIZE-1);
	end component;
	
	component multiplier is
		generic(DATA_WIDTH : integer :=32);
		port(
			a, b : in signed(DATA_WIDTH-1 downto 0);
			p : out signed(2*DATA_WIDTH-1 downto 0)
		);
	end component;
	
	component adder is
	generic(DATA_WIDTH : integer :=32);
	port(
		a, b : in signed(2*DATA_WIDTH-1 downto 0);
		add : out signed(2*DATA_WIDTH-1 downto 0)
	);
	end component;
	
	subtype data_value is signed(DATA_WIDTH-1 downto 0);
	subtype double_data_value is signed(2*DATA_WIDTH-1 downto 0);
	type data_vector is array(integer range MATRIX_SIZE-1 downto 0) of data_value;
	type double_data_vector is array(integer range MATRIX_SIZE-1 downto 0) of double_data_value;

	type const_mat is array(integer range MATRIX_SIZE-1 downto 0) of data_vector;

	-- Function to calculate Constant matrix
	function const return const_mat is
	variable a_val : const_mat;
		begin
		ConstMati_gen:	
		for i in MATRIX_SIZE-1 downto 0 loop
			ConstMatj_gen:
			for j in MATRIX_SIZE-1 downto 0 loop
				a_val(i)(j) := to_signed((((-1)**(i+j))*(i+1)*(j+1)),DATA_WIDTH);
			end loop ConstMatj_gen;
		end loop ConstMati_gen;
		return a_val;
	end function;

	-- Declaring constant matrix
	constant a_val : const_mat := const;
		
	signal x_val 		: 	data_vector; -- x_val(MATRIX_SIZE-1) down to x_val(0) are the DATA_WIDTH-bit values
	signal x_reg 		:	data_vector;
	signal y_val 		: 	double_data_vector  := (others => (others => '0')); -- Resulting y values
	signal ready_sig	: 	std_logic;
	signal Sel1 		: 	integer range 0 to MATRIX_SIZE-1;
	signal Sel2 		: 	integer range 0 to MATRIX_SIZE-1;
	signal Sel3 		: 	integer range 0 to MATRIX_SIZE-1;
	signal Sel			:	std_logic;
	signal xMul			: 	signed(DATA_WIDTH-1 downto 0);
	signal aMul			: 	signed(DATA_WIDTH-1 downto 0);
	signal ProductOut	:	signed(2*DATA_WIDTH-1 downto 0);
	signal ProductIn	:	signed(2*DATA_WIDTH-1 downto 0);
	signal AddOut		:	signed(2*DATA_WIDTH-1 downto 0);
	signal AdderOut	:	signed(2*DATA_WIDTH-1 downto 0);
	signal AdderIn		:	signed(2*DATA_WIDTH-1 downto 0);
	signal y_reg 		:	signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
	
	
begin

	-- Pack output y and unpack input x
	unpacking_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		x_val(i) <= x((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
		y((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= y_val(i)(DATA_WIDTH-1 downto 0);
	end generate;

	Sequential_part:
	process(clk, x, Start, ready_sig, AdderOut, ProductOut)
	begin
		if (clk'Event and clk = '1') then
			if (Start = '1' and ready_sig = '1') then
				x_reg <= x_val;
			end if;
			ProductIn <= ProductOut;
			AdderIn <= AdderOut;
			y_val(Sel2) <= AdderOut;
		end if;
	end process Sequential_part;
ready <= ready_sig;	
--	CTLBLK:
--	Control_blk generic map (Elements => MATRIX_SIZE)
--	port map	(
--					clk => clk,
--					start => start,
--					reset => reset,
--					Sel1 => Sel1,
--					Sel2 => Sel2,
--					Sel3 => Sel3,
--					Sel => Sel,
--					ready => ready_sig,
--					done => done
--				);
				
	
	CTLBLK:
	control_blk generic map (MATRIX_SIZE => MATRIX_SIZE)
	port map	(
					clk => clk,
					start => start,
					reset => reset,
					done => done,
					ready => ready_sig,
					sel => Sel,
					sel1 => Sel1,
					sel2 => Sel2,
					sel3 => Sel3
				);
	
	xMul <= x_reg(Sel1);
	aMul <= a_val(Sel2)(Sel1);
	
	MUL:
	multiplier generic map(DATA_WIDTH => DATA_WIDTH)
	port map	(
					a => xMul,
					b => aMul,
					p => ProductOut
				);
	
	ADD:
	adder generic map(DATA_WIDTH => DATA_WIDTH)
	port map	(
					a => ProductIn,
					b => AdderIn,
					add => AddOut
				);
				
	AdderOut <= AddOut when (Sel = '1') else (others => '0');
	
				
	
end behavioral;
