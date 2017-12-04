----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2017 02:19:21 PM
-- Design Name: 
-- Module Name: pc - Behavioral
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

entity pc_unit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           branch : in STD_LOGIC;
           condi : in STD_LOGIC;
           jump : in STD_LOGIC;
           offset : in STD_LOGIC_VECTOR (31 downto 0);
           addr : in STD_LOGIC_VECTOR (25 downto 0);
           pc_next : out STD_LOGIC_VECTOR (31 downto 0));
end pc_unit;

architecture Behavioral of pc_unit is
    
    signal pc : unsigned (31 downto 0) := TO_UNSIGNED(0, 32);
    signal pc_pl4 : unsigned (31 downto 0);
    signal pc_offset : unsigned (31 downto 0);
    signal pc_addr : unsigned (25 downto 0);
    signal pc_src : std_logic_vector (1 downto 0);  
    
begin

    -- pc_run
    pc_pl4 <= unsigned(pc) + 4;
    pc_offset <= UNSIGNED(offset(29 downto 0)&"00");
    pc_addr <= UNSIGNED(addr);
    pc_src(0) <= jump;
    pc_src(1) <= branch and (condi or jump);
    
    PC_SYNC : process(clk, rst)
    begin
        if (rst = '1') then 
            pc <= TO_UNSIGNED(0, 32);
        elsif rising_edge(clk) then
            case pc_src is
                when "00" =>                    -- next inst
                    pc <= pc_pl4;                              
                when "01" =>                    -- jump
                    pc <= pc_pl4(31 downto 28) & pc_addr & "00" ;
                when "10" =>                    -- branch
                    pc <= pc_offset + pc_pl4;
                when others =>                  -- halt
                    pc <= pc;
            end case;
        end if;
    end process;
    
    pc_next <= std_logic_vector(pc);

end Behavioral;
