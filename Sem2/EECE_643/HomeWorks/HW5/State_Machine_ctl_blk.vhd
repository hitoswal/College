--------------------------------Home Work 5---------------------------------
-----------------------------Hitesh Vijay Oswal-----------------------------
---------------------------------Sari Laga----------------------------------
---------------------------------EECE 643-----------------------------------
--------------------------------Spring 2016---------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_block_SM is
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
end Control_block_SM;

architecture Behavioral of Control_block_SM is
	
	type state is (Reset_stop, Start_s, Done_s, Con_Done_s, Read_s, Process_s1, Process_s2, Process_s3, Process_s4, Process_s5, Cont_Process_s5, Restart_s);
	signal Present_state, Next_state : state;
	signal count1, count2 : integer range 0 to MATRIX_SIZE - 1;
	signal done_sig, ready_sig, donesig, readysig, funreset : std_logic;
begin

done <= donesig;
ready <= readysig;
	
	process(clk, reset)
	begin
		if(clk'Event and clk = '1')then
			if(reset = '1') then
				Present_state <= Reset_stop;
			else
				Present_state <= Next_state;
			end if;
		end if;
	end process;
	
	process(Present_state, start, count1, count2, done_sig, ready_sig, donesig)
	begin
		case (Present_state) is
			
			when Reset_stop => 
				Sel1 <= 0;
				Sel2 <= 0;
				donesig <= '0';
				readysig <= '1';
				read_data <= '0';
				if(start = '1') then
					Next_state <= Read_s;
				else
					Next_state <= Reset_stop;
				end if;
				
			when Read_s =>
				Sel1 <= 0;
				Sel2 <= 0;
				donesig <= '0';
				readysig <= '0';
				read_data <= '1';
				Next_state <= Start_s;
			
			when Start_s =>
				Sel1 <= 1;
				Sel2 <= 0;
				donesig <= '0';
				readysig <= '0';
				read_data <= '0';
				Next_state <= Process_s1;
			
			when Process_s1 =>
				Sel1 <= 2;
				Sel2 <= 0;
				donesig <= '0';
				readysig <= '0';
				read_data <= '0';
				Next_state <= Process_s2;
			
			when Process_s2 =>
				Sel1 <= 3;
				Sel2 <= 1;
				donesig <= '0';
				readysig <= '0';
				read_data <= '0';
				Next_state <= Process_s3;
				
			when Process_s3 =>
				Sel1 <= 4;
				Sel2 <= 2;
				donesig <= '0';
				readysig <= '0';
				read_data <= '0';
				Next_state <= Process_s4;
			
			when Process_s4 =>
				Sel1 <= 0;
				Sel2 <= 3;
				donesig <= '0';
				readysig <= '1';
				read_data <= '0';
				if (start = '1') then
					Next_state <= Restart_s;
				else
					Next_state <= Process_s5;
				end if;
			
			when Process_s5 =>
				Sel1 <= 0;
				Sel2 <= 4;
				donesig <= '0';
				readysig <= '1';
				read_data <= '0';
				if (start = '1') then
					Next_state <= Cont_Process_s5;
				else
					Next_state <= Done_s;
				end if;
				
			when Restart_s =>
				Sel1 <= 0;
				Sel2 <= 4;
				donesig <= '0';
				readysig <= '0';
				read_data <= '1';
				Next_state <= Con_Done_s;
				
			when Done_s => 
				Sel1 <= 0;
				Sel2 <= 0;
				donesig <= '1';
				readysig <= '1';
				read_data <= '0';
				if (start = '1') then
					Next_state <= Read_s;
				else
					Next_state <= Reset_stop;
				end if;
				
			when Con_Done_s => 
				Sel1 <= 1;
				Sel2 <= 0;
				donesig <= '1';
				readysig <= '0';
				read_data <= '0';
				Next_state <= Process_s1;
				
			when Cont_Process_s5 => 
				Sel1 <= 1;
				Sel2 <= 0;
				donesig <= '1';
				readysig <= '0';
				read_data <= '1';
				Next_state <= Process_s1;
				

			when others => Next_state <= Reset_stop;
	end case;
	end process;
	
	
end Behavioral;

