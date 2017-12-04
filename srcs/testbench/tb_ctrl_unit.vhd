--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:06:47 12/03/2017
-- Design Name:   
-- Module Name:   E:/Final_AHD/myJob/tb_ctrl_unit.vhd
-- Project Name:  myJob
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ctrl_unit
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_ctrl_unit IS
END tb_ctrl_unit;
 
ARCHITECTURE behavior OF tb_ctrl_unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ctrl_unit
    PORT(
         lw : OUT  std_logic;
         sw : OUT  std_logic;
         branch : OUT  std_logic;
         bnc_type : OUT  std_logic_vector(1 downto 0);
         jump : OUT  std_logic;
         funct : OUT  std_logic_vector(2 downto 0);
         op2src : OUT  std_logic;
         regdst : OUT  std_logic;
         regwrt : OUT  std_logic;
         inst : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal inst : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal lw : std_logic;
   signal sw : std_logic;
   signal branch : std_logic;
   signal bnc_type : std_logic_vector(1 downto 0);
   signal jump : std_logic;
   signal funct : std_logic_vector(2 downto 0);
   signal op2src : std_logic;
   signal regdst : std_logic;
   signal regwrt : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
    type test_stage is (TESTING, FINISHED);
    signal stage : test_stage := TESTING;
	 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ctrl_unit PORT MAP (
          lw => lw,
          sw => sw,
          branch => branch,
          bnc_type => bnc_type,
          jump => jump,
          funct => funct,
          op2src => op2src,
          regdst => regdst,
          regwrt => regwrt,
          inst => inst
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		inst <= x"00000010";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="000" and op2src ='0' and regdst = '1' and regwrt='1'
			report "Wrong case 1"
				severity failure;
				
		inst <= x"04000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="000" and op2src ='1' and regdst = '0' and regwrt='1'
			report "Wrong case 2"
				severity failure;
				
		inst <= x"00000011";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="001" and op2src ='0' and regdst = '1' and regwrt='1'
			report "Wrong case 3"
				severity failure;
				
		inst <= x"08000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="001" and op2src ='1' and regdst = '0' and regwrt='1'
			report "Wrong case 4"
				severity failure;

		inst <= x"00000012";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="010" and op2src ='0' and regdst = '1' and regwrt='1'
			report "Wrong case 5"
				severity failure;
				
		inst <= x"0c000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="010" and op2src ='1' and regdst = '0' and regwrt='1'
			report "Wrong case 6"
				severity failure;
				
		inst <= x"00000013";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="011" and op2src ='0' and regdst = '1' and regwrt='1'
			report "Wrong case 7"
				severity failure;
				
		inst <= x"00000014";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="100" and op2src ='0' and regdst = '1' and regwrt='1'
			report "Wrong case 8"
				severity failure;				

		inst <= x"10000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="011" and op2src ='1' and regdst = '0' and regwrt='0'
			report "Wrong case 9"
				severity failure;
				
		inst <= x"14000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="101" and op2src ='1' and regdst = '0' and regwrt='0'
			report "Wrong case 10"
				severity failure;
				
		inst <= x"18000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="110" and op2src ='1' and regdst = '0' and regwrt='0'
			report "Wrong case 11"
				severity failure;
				
		inst <= x"1c000000";
		
		wait for 10 ns;
		assert lw='1' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="000" and op2src ='1' and regdst = '0' and regwrt='0'
			report "Wrong case 12"
				severity failure;				

		inst <= x"20000000";
		
		wait for 10 ns;
		assert lw='0' and sw='1' and branch='0' and bnc_type = "00" and jump='0' and funct="000" and op2src ='1' and regdst = '0' and regwrt='0'
			report "Wrong case 13"
				severity failure;
				
		inst <= x"24000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='1' and bnc_type = "10" and jump='0' and funct="000" and op2src ='0' and regdst = '0' and regwrt='0'
			report "Wrong case 14"
				severity failure;
				
		inst <= x"28000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='1' and bnc_type = "11" and jump='0' and funct="000" and op2src ='0' and regdst = '0' and regwrt='0'
			report "Wrong case 15"
				severity failure;
				
		inst <= x"2c000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='1' and bnc_type = "01" and jump='0' and funct="000" and op2src ='0' and regdst = '0' and regwrt='0'
			report "Wrong case 16"
				severity failure;		

		inst <= x"30000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='1' and funct="000" and op2src ='0' and regdst = '0' and regwrt='0'
			report "Wrong case 17"
				severity failure;
				
		inst <= x"fc000000";
		
		wait for 10 ns;
		assert lw='0' and sw='0' and branch='0' and bnc_type = "00" and jump='0' and funct="000" and op2src ='0' and regdst = '0' and regwrt='0'
			report "Wrong case 18"
				severity failure;
		

				
	 stage <= FINISHED;
    report "1000 cases passed.";
      -- insert stimulus here 

      wait;
   end process;


END;
