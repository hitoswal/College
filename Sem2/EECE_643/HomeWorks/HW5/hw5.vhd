--------------------------------Home Work 5---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

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
entity hw5 is
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
end hw5;

architecture behavioral of hw5 is
	
	component AdderBlk is
		generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		port(
			Mult : in signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0);
			Addition : out signed(2*DATA_WIDTH-1 downto 0)
		);
	end component;
	
	component Multblk is
		generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		port(
			x : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
			a : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
			Mult : out signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0)
		);
	end component;
	
	component Demux_test is
		generic (DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		 Port( 	
			AdderOut : in  signed (DATA_WIDTH-1 downto 0);
			sel:		in	 integer range 0 to MATRIX_SIZE-1;
			clk: in STD_LOGIC;
			y_out : out  signed (MATRIX_SIZE*DATA_WIDTH-1 downto 0)
		);
	end component;

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
	
	constant a_val	:	const_mat 	:= const;
	signal x_val 	: 	data_vector;        -- x_val(MATRIX_SIZE-1) down to x_val(0) are the DATA_WIDTH-bit values
	signal y_val 	: 	double_data_vector; -- Resulting y values
	signal a 		: 	signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
	signal a_reg	: 	signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
	signal Sel1 	: 	integer range 0 to MATRIX_SIZE-1;
	signal Sel2 	: 	integer range 0 to MATRIX_SIZE-1;
	signal Mult		:	signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0);
	signal Mult_reg		:	signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0);
	signal Addition:	signed(2*DATA_WIDTH-1 downto 0);
	signal x_reg     	:	signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
	signal read_data	:	STD_LOGIC; 
	
	begin
	-- Pack output y and unpack input x
	packing_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		a((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= a_val(i)(Sel1);
	end generate;
	
	Mult_blk:
	Multblk generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	port map (
					x => x_reg,
					a => a_reg,
					Mult => Mult
				);
				
	Adr_blk:
	AdderBlk generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	port map (
					Mult => Mult_reg,
					Addition => Addition
				);
	
	Demux: 
	Demux_test generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
	port map ( 
					AdderOut => Addition(DATA_WIDTH - 1 downto 0),
					sel => Sel2,
					clk => clk,
					y_out => y
				);

	ctl_block:
	Control_block_SM generic map (MATRIX_SIZE => MATRIX_SIZE)
	port map	(
					clk	=> clk,
					start	=> start,
					reset	=> reset,
					read_data => read_data,
					Sel1	=> Sel1,
					Sel2	=> Sel2,
					done	=> done,
					ready => ready
				);
				
	process(clk, reset, Mult)
	begin
		if (clk'event and clk = '1') then
			if (reset = '1') then
				Mult_reg <= (others => '0');
			else
				Mult_reg <= Mult;
				a_reg <= a;
				if (read_data = '1') then
					x_reg <= x;
				end if;
			end if;
		end if;
	end process;

end behavioral;
