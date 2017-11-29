----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2017 08:11:18 PM
-- Design Name: 
-- Module Name: seg_led - Behavioral
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

entity seg_led is
    Port ( seg_din : in STD_LOGIC_VECTOR (31 downto 0);
           led_din : in STD_LOGIC_VECTOR (31 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           an : out std_logic_vector (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC);
end seg_led;

architecture Behavioral of seg_led is

begin

    seg <= seg_din(6 downto 0);
    dp <= seg_din(7);
    an <= (others=>'0');
    led <= led_din(15 downto 0);

end Behavioral;
