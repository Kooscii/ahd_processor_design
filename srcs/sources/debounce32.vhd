----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2017 02:05:24 PM
-- Design Name: 
-- Module Name: debounce32 - Behavioral
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

entity debounce32 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (31 downto 0);
           dout : out STD_LOGIC_VECTOR (31 downto 0));
end debounce32;

architecture Behavioral of debounce32 is

    component debounce is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               din : in STD_LOGIC;
               dout : out STD_LOGIC
             );
    end component;
    
begin
    
    dout(31 downto 21) <= (others => '0');
    U_debounce20 : debounce port map (clk=>clk, rst=>rst, din=>din(20), dout=>dout(20));
    U_debounce19 : debounce port map (clk=>clk, rst=>rst, din=>din(19), dout=>dout(19));
    U_debounce18 : debounce port map (clk=>clk, rst=>rst, din=>din(18), dout=>dout(18));
    U_debounce17 : debounce port map (clk=>clk, rst=>rst, din=>din(17), dout=>dout(17));
    U_debounce16 : debounce port map (clk=>clk, rst=>rst, din=>din(16), dout=>dout(16));
    U_debounce15 : debounce port map (clk=>clk, rst=>rst, din=>din(15), dout=>dout(15));
    U_debounce14 : debounce port map (clk=>clk, rst=>rst, din=>din(14), dout=>dout(14));
    U_debounce13 : debounce port map (clk=>clk, rst=>rst, din=>din(13), dout=>dout(13));
    U_debounce12 : debounce port map (clk=>clk, rst=>rst, din=>din(12), dout=>dout(12));
    U_debounce11 : debounce port map (clk=>clk, rst=>rst, din=>din(11), dout=>dout(11));
    U_debounce10 : debounce port map (clk=>clk, rst=>rst, din=>din(10), dout=>dout(10));
    U_debounce9 : debounce port map (clk=>clk, rst=>rst, din=>din(9), dout=>dout(9));
    U_debounce8 : debounce port map (clk=>clk, rst=>rst, din=>din(8), dout=>dout(8));
    U_debounce7 : debounce port map (clk=>clk, rst=>rst, din=>din(7), dout=>dout(7));
    U_debounce6 : debounce port map (clk=>clk, rst=>rst, din=>din(6), dout=>dout(6));
    U_debounce5 : debounce port map (clk=>clk, rst=>rst, din=>din(5), dout=>dout(5));
    U_debounce4 : debounce port map (clk=>clk, rst=>rst, din=>din(4), dout=>dout(4));
    U_debounce3 : debounce port map (clk=>clk, rst=>rst, din=>din(3), dout=>dout(3));
    U_debounce2 : debounce port map (clk=>clk, rst=>rst, din=>din(2), dout=>dout(2));
    U_debounce1 : debounce port map (clk=>clk, rst=>rst, din=>din(1), dout=>dout(1));
    U_debounce0 : debounce port map (clk=>clk, rst=>rst, din=>din(0), dout=>dout(0));

end Behavioral;
