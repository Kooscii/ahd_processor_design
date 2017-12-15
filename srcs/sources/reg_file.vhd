----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2017 07:51:14 PM
-- Design Name: 
-- Module Name: reg_file - Behavioral
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

entity reg_file is
    Port ( rd1 : out STD_LOGIC_VECTOR (31 downto 0);
           rd2 : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
--           rst : in STD_LOGIC;
           we : in STD_LOGIC;
           rs : in STD_LOGIC_VECTOR (4 downto 0);
           rt : in STD_LOGIC_VECTOR (4 downto 0);
           rd : in STD_LOGIC_VECTOR (4 downto 0);
           wd : in STD_LOGIC_VECTOR (31 downto 0)
--           r31 : in STD_LOGIC_VECTOR (31 downto 0); -- btn & sw read-only
--           r30 : out STD_LOGIC_VECTOR (31 downto 0); -- 7-seg display
--           r29 : out STD_LOGIC_VECTOR (31 downto 0) -- led display
           );
end reg_file;

architecture Behavioral of reg_file is
    TYPE REGF IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reg : REGF := (others=>std_logic_vector(TO_UNSIGNED(0, 32)));

begin

process (clk)
begin
--    if (rst = '1') then 
--        reg(0 to 31) <= (OTHERS => std_logic_vector( TO_UNSIGNED(0, 32)));
    if rising_edge(clk) then
        if we = '1' then -- and TO_INTEGER( unsigned(rd)) > 1 then 
            reg( TO_INTEGER( unsigned(rd))) <= wd;
        end if;
--        reg(31) <= r31;
--        r30 <= reg(30);
--        r29 <= reg(29);

    end if;
    -- r0 always be 0 and read-only
--    reg(0) <= STD_LOGIC_VECTOR( TO_UNSIGNED(0, 32));
    -- r1 always be 1 and read-only
--    reg(1) <= STD_LOGIC_VECTOR( TO_UNSIGNED(1, 32));

--    rd1 <= reg( TO_INTEGER( unsigned(rs)));
--    rd2 <= reg( TO_INTEGER( unsigned(rt)));
    
end process;

rd1 <= reg( TO_INTEGER( unsigned(rs)));
rd2 <= reg( TO_INTEGER( unsigned(rt)));
--r30 <= (others=>'0');
--r29 <= (others=>'0');
--r30 <= reg(30);
--r29 <= reg(29);
--r30 <= r31;
--r29 <= r31;

end Behavioral;
