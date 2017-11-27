--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:05:53 11/22/2017
-- Design Name:   
-- Module Name:   C:/Users/hyq/Desktop/IMem/ins_mem/ins_mem_tb.vhd
-- Project Name:  ins_mem
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ins_mem
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
 
ENTITY ins_mem_tb IS
END ins_mem_tb;
 
ARCHITECTURE behavior OF ins_mem_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ins_mem
    PORT(
         inst : OUT  std_logic_vector(31 downto 0);
         addr : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal addr : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal inst : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	signal clk : std_logic;
 
   constant clk_period : time := 100 ns;
   
   -- memory
   type memory is array(0 to 7) of STD_LOGIC_VECTOR (31 downto 0);
   signal myMem: memory:= (
       X"00000001",
       X"00000010",
       X"00000100",
       X"00001000",
       X"00010000",
       X"00100000",
       X"01000000",
       X"10000000"
       );
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ins_mem PORT MAP (
          inst => inst,
          addr => addr
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
     
      -- insert stimulus here 
		 addr<=X"00000000";
		 wait for clk_period;
		 addr<=X"00000004";
		 wait for clk_period;
		 addr<=X"00000008";
		 wait for clk_period;
		 addr<=X"0000000C";
		 wait for clk_period;
		 addr<=X"00000010";
		 wait for clk_period;
		 addr<=X"00000000";
		 wait for clk_period;
		 addr<=X"00000004";
		 wait for clk_period;
		 addr<=X"00000008";
		 wait for clk_period;
		 addr<=X"0000000C";
		 wait for clk_period;
		 addr<=X"00000010";
		 wait for clk_period;
      wait;
   end process;

END;
