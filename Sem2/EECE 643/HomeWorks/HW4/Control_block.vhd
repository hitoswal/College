--------------------------------Home Work 4---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_block is
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
end Control_block;

architecture Behavioral of Control_block is
	
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
	
	type state is (Reset_stop, Start_s, Done_s, Read_s);
	signal Present_state, Next_state : state;
	signal count1, count2, count3 : integer range 0 to MATRIX_SIZE - 1;
	signal count, done_sig, ready_sig, donesig, readysig, funreset : std_logic;
begin

done <= donesig;
ready <= readysig;
	
fun:	control_blk generic map (MATRIX_SIZE => MATRIX_SIZE)
	port map	(
					clk => clk,
					start => start,
					reset => funreset,
					done => done_sig,
					ready => ready_sig,
					sel => count,
					sel1 => count1,
					sel2 => count2,
					sel3 => count3
				);
	
	process(clk, reset)
	begin
		if(reset = '1') then
			Present_state <= Reset_stop;
		elsif(clk'Event and clk = '1')then
			Present_state <= Next_state;
		end if;
	end process;
	
	process(Present_state, start, count1, count2, count3, count, done_sig, ready_sig, donesig)
	begin
		case (Present_state) is
			
			when Reset_stop => 
				Sel1 <= 0;
				Sel2 <= 0;
				Sel3 <= 0;
				Sel <= '0';
				donesig <= '0';
				readysig <= '1';
				funreset <= '1';
				read_data <= '0';
				if(start = '1') then
					Next_state <= Read_s;
				else
					Next_state <= Reset_stop;
				end if;
			
			when Start_s =>
				Sel1 <= count1;
				Sel2 <= count2;
				Sel3 <= count3;
				Sel <= count;
				donesig <= '0';
				readysig <= '0';
				funreset <= '0';
				read_data <= '0';
				if (done_sig = '1') then
					Next_state <= Done_s;
				else
					Next_state <= Start_s;
				end if;
			
			when Done_s => 
				Sel1 <= 0;
				Sel2 <= 0;
				Sel3 <= 0;
				Sel <= '0';
				donesig <= '1';
				readysig <= '1';
				funreset <= '1';
				read_data <= '0';
				if(start = '1') then
					Next_state <= Read_s;
				else
					Next_state <= Reset_stop;
				end if;
			
			when Read_s =>
				Sel1 <= 0;
				Sel2 <= 0;
				Sel3 <= 0;
				Sel <= '0';
				donesig <= '0';
				readysig <= '0';
				funreset <= '1';
				read_data <= '1';
				Next_state <= Start_s;
			
			when others => Next_state <= Reset_stop;
	end case;
	end process;
	
	
end Behavioral;

