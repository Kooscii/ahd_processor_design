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
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
 
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
    
  type test_stage is (TESTING, FINISHED);
   signal stage : test_stage := TESTING;
  
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
  variable seed1 : positive; 
   variable seed2 : positive;
   variable rand : real;
   variable rand_range1 : real := 256.0;
   variable rand_offset1 : integer := 0;
  variable rand_range2 : real := 4294967296.0;
   variable rand_offset2 : integer := 0;
  variable temp : integer :=0;
  variable randomInstruction : std_logic_vector (31 downto 0);
  variable randomAddress : std_logic_vector (7 downto 0);
   begin    
  wait for 100ns;
      -- insert stimulus here 
    -- 1000 random cases
        for k in 1 to 1000 loop
            uniform(seed1, seed2, rand);
        randomAddress:=  std_logic_vector(TO_SIGNED(integer(trunc(rand*rand_range1))+rand_offset1, 8));
            uniform(seed1, seed2, rand);
        randomInstruction:=  std_logic_vector(TO_SIGNED(integer(trunc(rand*rand_range2))+rand_offset2, 32));
            temp:= integer(trunc(rand*rand_range2))+rand_offset2;
      
        wd<=randomInstruction;
        addr(9 downto 2)<=randomAddress;
        wait for w_clk_period;
            assert TO_INTEGER(unsigned(inst)) = temp
                report "Wrong instruction"
                    severity failure;
        end loop;
        
        stage <= FINISHED;
        report "1000 cases passed.";
        
        wait;
   end process;

END;
