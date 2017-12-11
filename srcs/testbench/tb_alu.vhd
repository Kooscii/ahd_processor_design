LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_test IS
END alu_test;
 
ARCHITECTURE behavior OF alu_test IS 
 
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
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          result => result,
          eq => eq,
          op1 => op1,
          op2 => op2,
          funct => funct,
			 lt => lt
        );

  

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		
      wait for 100 ns;	
		op1<="00000000000111110000000000000000";
		wait for 10 ns;
		op2<="00000001000000111100001111111000";
		wait for 10 ns;
		funct<="000";
		wait for 10 ns;
		funct<="001";
		wait for 10 ns;
		funct<="010";
		op1<="00000001000000111100001111111000";
		wait for 10 ns;
		funct<="011";

		wait for 10 ns;
		funct<="100";

		wait for 10 ns;
		funct<="101";

		wait for 10 ns;
		funct<="110";
		wait for 10 ns;
		funct<="111";


      -- insert stimulus here 

      wait;
   end process;

END;
