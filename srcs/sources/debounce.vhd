----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2017 08:02:34 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           din : in STD_LOGIC;
           dout : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    type type_state is (IDLE, DELAY);
    signal state : type_state := IDLE;
    
    signal stable_din : std_logic := '0';
    
begin
    
    process (clk, rst)
        variable t : integer := 0;
    begin
    
        if rst = '1' then
            t := 0;
            state <= IDLE;
            stable_din <= din;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if din /= stable_din then
                        t := 0;
                        state <= DELAY;
                    end if;
                when others =>
                    t := t + 1;
                    if t > 5000000 then
                        t := 0;
                        stable_din <= din;
                        state <= IDLE;
                    end if;    
            end case;
        end if;
    
    end process;
    
    dout <= stable_din;

end Behavioral;
