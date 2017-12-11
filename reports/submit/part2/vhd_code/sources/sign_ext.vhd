----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2017 07:51:14 PM
-- Design Name: 
-- Module Name: sign_ext - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sign_ext is
    Port ( imm32 : out STD_LOGIC_VECTOR (31 downto 0);
           imm16 : in STD_LOGIC_VECTOR (15 downto 0));
end sign_ext;

architecture Behavioral of sign_ext is

begin

    imm32 <= STD_LOGIC_VECTOR( TO_SIGNED( TO_INTEGER( signed(imm16) ), 32) );

end Behavioral;
