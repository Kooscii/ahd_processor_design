----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2017 03:10:02 PM
-- Design Name: 
-- Module Name: reset_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reset_unit is
    Port ( clk : in STD_LOGIC;
           rst_in : in STD_LOGIC;
           rst_out : out STD_LOGIC);
end reset_unit;

architecture Behavioral of reset_unit is

begin

    process (clk, rst_in)
    begin
        
        if rst_in = '1' then
            rst_out <= '1';
        elsif rising_edge(clk) then
            rst_out <= rst_in;
        end if; 
    
    end process;

end Behavioral;
