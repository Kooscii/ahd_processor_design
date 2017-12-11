----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2017 08:45:31 PM
-- Design Name: 
-- Module Name: tb_debounce - Behavioral
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

entity tb_debounce is
--  Port ( );
end tb_debounce;

architecture Behavioral of tb_debounce is
    component debounce is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               din : in STD_LOGIC;
               dout : out STD_LOGIC);
    end component;
    
    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal din : std_logic;
    signal dout : std_logic;
    
    constant clk_period : time := 10 ns;
    
begin
    clk <= not clk after clk_period/2;
    
    UUT_debounce : debounce
        port map ( clk => clk,
                   rst => rst,
                   din => din,
                   dout => dout);
    
    process
    begin

        rst <= '1';
        din <= '0';
        wait for 200ns;
        
        rst <= '0';
        wait for 10ms;
        
        din <= '1';
        wait for 1ms;
        for k in 1 to 20 loop
            din <= not din;
            wait for 1ms;
            din <= not din;
            wait for 1ms;
        end loop;
        wait for 30ms;
        
        din <= '0';
        wait for 1ms;
        for k in 1 to 20 loop
            din <= not din;
            wait for 1ms;
            din <= not din;
            wait for 1ms;
        end loop;
        
        wait;
                

    end process;

end Behavioral;
