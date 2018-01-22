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
 
ENTITY MultiBlk_tb IS
generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
END MultiBlk_tb;
 
ARCHITECTURE behavior OF MultiBlk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Multblk is
		 generic(DATA_WIDTH : integer :=32; MATRIX_SIZE : integer :=5);
		 port(
				x : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
				a : in signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0);
				Mult : out signed(MATRIX_SIZE*2*DATA_WIDTH-1 downto 0)
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
	
	function compare(a, b : data_vector; M : signed(2*MATRIX_SIZE*DATA_WIDTH-1 downto 0)) return boolean is
--	variable x_valc : data_vector;
--	variable a_vectc : data_vector;
	variable Mult_valc : double_data_vector;
	variable Multc : signed(2*MATRIX_SIZE*DATA_WIDTH-1 downto 0);
	begin
--		unpacking_loop:
--		for i in MATRIX_SIZE-1 downto 0 loop
--			x_valc(i) := a((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
--			a_vectc(i) := b((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
--		end loop unpacking_loop;
		
		mult_loop:
		for i in MATRIX_SIZE-1 downto 0 loop	
			Mult_valc(i) :=	a(i) * b(i);
		end loop mult_loop;
		
		packing_loop:
		for i in MATRIX_SIZE-1 downto 0 loop
			Multc((i+1)*2*DATA_WIDTH-1 downto i*2*DATA_WIDTH) := Mult_valc(i)(2*DATA_WIDTH-1 downto 0);
		end loop packing_loop;
		
		if (Multc = M) then
			return True;
		else
			return False;
		end if;
	end function;
	
	constant a_val	:	const_mat 	:= const;

   --Inputs
   signal x : signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0) := (others => '0');
   signal a : signed(MATRIX_SIZE*DATA_WIDTH-1 downto 0) := (others => '0');

 	--Outputs
   signal Mult : signed(2*MATRIX_SIZE*DATA_WIDTH-1 downto 0) := (others => '0');
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	
	--Signals
   signal x_val : data_vector;
	signal a_vect : data_vector;
	signal Mult_val : double_data_vector;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Multblk generic map (DATA_WIDTH => DATA_WIDTH, MATRIX_SIZE => MATRIX_SIZE)
		  PORT MAP (
          x => x,
          a => a,
          Mult => Mult
        );
	
	packing_loop:
	for i in MATRIX_SIZE-1 downto 0 generate
		x((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= x_val(i);
		a((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= a_vect(i);
		Mult_val(i)(2*DATA_WIDTH-1 downto 0) <= Mult((i+1)*2*DATA_WIDTH-1 downto i*2*DATA_WIDTH);
	end generate packing_loop;
	
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		-- insert stimulus here 
		x_val <= (to_signed(5, DATA_WIDTH),to_signed(4, DATA_WIDTH),to_signed(3, DATA_WIDTH),to_signed(2, DATA_WIDTH),to_signed(1, DATA_WIDTH));
		a_vect <= (a_val(0)(0),a_val(0)(1),a_val(0)(2),a_val(0)(3),a_val(0)(4));
		wait for 10 ns;
		if (compare(x_val, a_vect, Mult) = True) then
			write(output, "Sucess" & LF);
		else
			write(output, "Fail" & LF);
		end if;
		x_val <= (to_signed(5, DATA_WIDTH),to_signed(4, DATA_WIDTH),to_signed(3, DATA_WIDTH),to_signed(2, DATA_WIDTH),to_signed(1, DATA_WIDTH));
		a_vect <= (a_val(1)(0),a_val(1)(1),a_val(1)(2),a_val(1)(3),a_val(1)(4));
		wait for 10 ns;
		if (compare(x_val, a_vect, Mult) = True) then
			write(output, "Sucess" & LF);
		else
			write(output, "Fail" & LF);
		end if;
		x_val <= (to_signed(5, DATA_WIDTH),to_signed(4, DATA_WIDTH),to_signed(3, DATA_WIDTH),to_signed(2, DATA_WIDTH),to_signed(1, DATA_WIDTH));
		a_vect <= (a_val(2)(0),a_val(2)(1),a_val(2)(2),a_val(2)(3),a_val(2)(4));
		wait for 10 ns;
		if (compare(x_val, a_vect, Mult) = True) then
			write(output, "Sucess" & LF);
		else
			write(output, "Fail" & LF);
		end if;
		x_val <= (to_signed(5, DATA_WIDTH),to_signed(4, DATA_WIDTH),to_signed(3, DATA_WIDTH),to_signed(2, DATA_WIDTH),to_signed(1, DATA_WIDTH));
		a_vect <= (a_val(3)(0),a_val(3)(1),a_val(3)(2),a_val(3)(3),a_val(3)(4));
		wait for 10 ns;
		if (compare(x_val, a_vect, Mult) = True) then
			write(output, "Sucess" & LF);
		else
			write(output, "Fail" & LF);
		end if;
		x_val <= (to_signed(5, DATA_WIDTH),to_signed(4, DATA_WIDTH),to_signed(3, DATA_WIDTH),to_signed(2, DATA_WIDTH),to_signed(1, DATA_WIDTH));
		a_vect <= (a_val(4)(0),a_val(4)(1),a_val(4)(2),a_val(4)(3),a_val(4)(4));
		wait for 10 ns;
		if (compare(x_val, a_vect, Mult) = True) then
			write(output, "Sucess" & LF);
		else
			write(output, "Fail" & LF);
		end if;
      finish(0);
		wait;
   end process;

END;
