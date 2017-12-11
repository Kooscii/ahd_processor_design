LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY kkkt IS
END kkkt;
 
ARCHITECTURE behavior OF kkkt IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         result : OUT  std_logic_vector(31 downto 0);
         eq : OUT  std_logic;
         lt : OUT  std_logic;
         op1 : IN  std_logic_vector(31 downto 0);
         op2 : IN  std_logic_vector(31 downto 0);
         funct : IN  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal op1 : std_logic_vector(31 downto 0) := (others => '0');
   signal op2 : std_logic_vector(31 downto 0) := (others => '0');
   signal funct : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(31 downto 0);
   signal eq : std_logic;
   signal lt : std_logic;
	signal teq : std_logic;
   signal tlt : std_logic;
	type test_stage is (TESTING, FINISHED);
   signal stage : test_stage := TESTING;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          result => result,
          eq => eq,
          lt => lt,
          op1 => op1,
          op2 => op2,
          funct => funct

        );

   -- Clock process definitions

 testbench : process
        variable seed1 : positive; 
        variable seed2 : positive;
        variable rand1 : real;
        variable rand2 : real;
        variable rand_range : real := 4294967295.0;
        variable rand_offset : integer := -2147483648;

   begin	
        -- 1000 random cases
		  			wait for 100 ns;
        for k in 1 to 1000 loop
            uniform(seed1, seed2, rand1);
				uniform(seed2, seed1, rand2);
            op1 <=  std_logic_vector(TO_SIGNED(integer(trunc(rand1*rand_range))+rand_offset, 32));
            op2 <=  std_logic_vector(TO_SIGNED(integer(trunc(rand2*rand_range))+rand_offset, 32));
			wait for 20 ns;
			assert eq= teq and lt=tlt
				report "Wrong case eq and lt"
					severity failure;
			funct<="000";
			wait for 20 ns;
			assert result= op1 + op2 
				report "Wrong case +"
					severity failure;
			funct<="001";
			wait for 20 ns;
			assert result= op1 - op2 
				report "Wrong case -"
					severity failure;
			funct<="010";
			wait for 20 ns;
			assert result= (op1 and op2) 
				report "Wrong case and"
				severity failure;	
			funct<="011";
			wait for 20 ns;
			assert result= (op1 or op2) 
				report "Wrong case or"
					severity failure;
			funct<="100";			
			wait for 20 ns;
			assert result= (not (op1 or op2)) 
				report "Wrong case not or"
					severity failure;
			funct<="101";				
			wait for 20 ns;
			assert result= Std_Logic_Vector(unsigned(op1) sll  to_integer(unsigned(op2(5 downto 0))))
				report "Wrong case left"
					severity failure;	
			funct<="110";				
			wait for 20 ns;
			assert result= Std_Logic_Vector(unsigned(op1) srl  to_integer(unsigned(op2(5 downto 0))))
				report "Wrong case right"
					severity failure;	
			funct<="111";				
			wait for 20 ns;
        end loop;

        stage <= FINISHED;
        report "1000 cases passed.";
        
        wait;
 
   end process;
process(op1,op2)
	begin
	if signed(op1)=signed(op2) then
	  teq<='1';
	  tlt<='0';
	elsif signed(op1)<signed(op2) then
	  tlt<='1';
	  teq<='0';
	else
	  teq<='0';
	  tlt<='0';
 
end if;
end process; 
END;
