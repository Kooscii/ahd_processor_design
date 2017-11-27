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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file is
    Port ( rd1 : out STD_LOGIC_VECTOR (31 downto 0);
           rd2 : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           we : in STD_LOGIC;
           rs : in STD_LOGIC_VECTOR (4 downto 0);
           rt : in STD_LOGIC_VECTOR (4 downto 0);
           rd : in STD_LOGIC_VECTOR (4 downto 0);
           wd : in STD_LOGIC_VECTOR (31 downto 0));
end reg_file;

architecture Behavioral of reg_file is
    TYPE REGF IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reg : REGF;

begin

process (clk, rst)
begin
    if (rst = '1') then reg <= (OTHERS => "00000000000000000000000000000000");
    elsif (clk'event and clk = '1') then
        if (we = '1') then reg(CONV_INTEGER(rd(4 DOWNTO 0))) <= wd(31 DOWNTO 0);
        end if;
    end if;
end process;

rd1 <= reg(CONV_INTEGER(rs(4 DOWNTO 0)));
rd2 <= reg(CONV_INTEGER(rt(4 DOWNTO 0)));

end Behavioral;
