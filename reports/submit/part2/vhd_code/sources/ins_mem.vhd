----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:10:34 11/22/2017 
-- Design Name: 
-- Module Name:    ins_mem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ins_mem is
    Port ( inst : out STD_LOGIC_VECTOR (31 downto 0);
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           wd: in STD_LOGIC_VECTOR (31 downto 0);
           w_clk: in STD_LOGIC);
end ins_mem;

architecture Behavioral of ins_mem is
    type memory is array(0 to 511) of STD_LOGIC_VECTOR (31 downto 0); --can be changed later
    signal myMem: memory:= (others=> std_logic_vector( TO_UNSIGNED(0, 32)));
begin

     process(w_clk)
     begin
        if rising_edge(w_clk) then
            myMem(TO_INTEGER( UNSIGNED(addr(31 downto 2))))<=wd;
        end if;
     end process;
     
     inst<=myMem( TO_INTEGER( UNSIGNED( addr(31 downto 2))));
    
end Behavioral;