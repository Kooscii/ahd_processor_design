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
    type type_state is (IDLE, PRESSED, RELEASED);
    signal state : type_state := IDLE;
    
--    constant cooldown: integer := 10000;
    constant cooldown: integer := 1;
        
begin
    
    process (clk, rst)
        variable t : integer := 0;
    begin
    
        if rst = '1' then
            t := 0;
            state <= IDLE;
            dout <= din;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    dout <= din;
                    if din = '1' then
                        t := 0;
                        state <= PRESSED;
                    end if;
                when PRESSED =>     -- down-sampling
                    t := t + 1;
                    if t = cooldown then
                        if din = '0' then
                            state <= RELEASED;
                        end if;
                        t := 0;
                    end if;  
                when RELEASED =>     -- down-sampling
                    t := t + 1;
                    if t = cooldown then
                        if din = '0' then
                            state <= IDLE;
                        end if;
                        t := 0;
                    end if;      
            end case;
        end if;
    
    end process;
    
end Behavioral;
