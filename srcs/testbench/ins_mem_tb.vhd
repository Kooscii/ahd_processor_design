--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:40:26 11/30/2017
-- Design Name:   
-- Module Name:   C:/Users/hyq/Desktop/IMem/ins_mem/ins_memTest.vhd
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
 
ENTITY ins_memTest IS
END ins_memTest;
 
ARCHITECTURE behavior OF ins_memTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ins_mem
    PORT(
         inst : OUT  std_logic_vector(31 downto 0);
         addr : IN  std_logic_vector(31 downto 0);
         wd : IN  std_logic_vector(31 downto 0);
         w_clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal addr : std_logic_vector(31 downto 0) := (others => '0');
   signal wd : std_logic_vector(31 downto 0) := (others => '0');
   signal w_clk : std_logic := '0';

  --Outputs
   signal inst : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant w_clk_period : time := 100 ns;
  
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
   uut: ins_mem PORT MAP (
          inst => inst,
          addr => addr,
          wd => wd,
          w_clk => w_clk
        );

   -- Clock process definitions
   w_clk_process :process
   begin
    w_clk <= '0';
    wait for w_clk_period/2;
    w_clk <= '1';
    wait for w_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin    
      -- insert stimulus here 
    wait for w_clk_period;
    wd<=X"00000001";
    addr<=X"00000000";
    wait for w_clk_period;
    wd<=X"00000010";
    addr<=X"00000004";
    wait for w_clk_period;
    wd<=X"00000100";
    addr<=X"00000008";
    wait for w_clk_period;
    wd<=X"00001000";
    addr<=X"0000000C";
    wait for w_clk_period;
    wd<=X"00010000";
    addr<=X"00000010";
    wait for w_clk_period;
    wd<=X"00100000";
    addr<=X"00000014";
    wait for w_clk_period;
    wd<=X"01000000";
    addr<=X"00000018";
    wait for w_clk_period;
    wd<=X"10000000";
    addr<=X"0000001C";
    wait for w_clk_period;

      wait;
   end process;

END;
