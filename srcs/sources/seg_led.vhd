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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seg_led is
    Port ( seg_din : in STD_LOGIC_VECTOR (31 downto 0);
           led_din : in STD_LOGIC_VECTOR (31 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
--           dp : out STD_LOGIC;
           an : out std_logic_vector (7 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           rst : in STD_LOGIC;
           clk : in STD_LOGIC);
end seg_led;

architecture Behavioral of seg_led is

    type type_segcode is array (0 to 15) of std_logic_vector (6 downto 0);
    constant seg_code : type_segcode := (
        "1000000", "1111001", "0100100", "0110000",
        "0011001", "0010010", "0000010", "1111000",
        "0000000", "0010000", "0001000", "0000011",
        "1000110", "0100001", "0000110", "0001110");
        
    type type_ancode is array (0 to 7) of std_logic_vector (7 downto 0);
    constant an_code : type_ancode := (
        "11111110", "11111101", "11111011", "11110111",
        "11101111", "11011111", "10111111", "01111111");
    
    signal i : integer := 7;
    
--    constant refresh_delay: integer := 50000;
    constant refresh_delay: integer := 2;
    
begin
    
    process (clk, rst)
        variable t : integer := 0;
    begin
        if rst = '1' then
            t := 0;
            i <= 7;
        elsif rising_edge(clk) then
            t := t + 1;
            if t = refresh_delay then      -- refresh rate 1000Hz
                t := 0;
                an <= "11111111";
                if i = 0 then
                    i <= 7;
                else
                    i <= i - 1;
                end if;
            elsif t = 1 then
                an <= an_code(i);
            end if;
        end if;
    end process;
    
    led <= led_din(15 downto 0);
    seg <= seg_code(TO_INTEGER(unsigned(seg_din(i*4+3 downto i*4))));
--    dp <= '1';
    
end Behavioral;
