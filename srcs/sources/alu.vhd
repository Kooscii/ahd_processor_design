----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2017 07:51:14 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
    Port ( result : out STD_LOGIC_VECTOR (31 downto 0);
           eq : out STD_LOGIC;
           lt : out STD_LOGIC;
           op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           funct : in STD_LOGIC_VECTOR (2 downto 0));
end alu;

architecture Behavioral of alu is
    
    signal lsft : std_logic_vector (31 downto 0);
    signal rsft : std_logic_vector (31 downto 0);
    signal diff : signed (32 downto 0);

begin

    with TO_INTEGER(unsigned(funct)) select result <=
        std_logic_vector(unsigned(op1) + unsigned(op2)) when 0,
        std_logic_vector(unsigned(op1) - unsigned(op2)) when 1,
        op1 and op2                                     when 2,
        op1 or  op2                                     when 3,
        not (op1 or op2)                                when 4,
        lsft                                            when 5,
        rsft                                            when 6,
        (others => '0')                                 when others;
        
    with TO_INTEGER(unsigned(op2(5 downto 0))) select lsft <=
        op1(31 downto 0) when 0,
        op1(30 downto 0) & std_logic_vector(TO_UNSIGNED(0, 1)) when 1,
        op1(29 downto 0) & std_logic_vector(TO_UNSIGNED(0, 2)) when 2,
        op1(28 downto 0) & std_logic_vector(TO_UNSIGNED(0, 3)) when 3,
        op1(27 downto 0) & std_logic_vector(TO_UNSIGNED(0, 4)) when 4,
        op1(26 downto 0) & std_logic_vector(TO_UNSIGNED(0, 5)) when 5,
        op1(25 downto 0) & std_logic_vector(TO_UNSIGNED(0, 6)) when 6,
        op1(24 downto 0) & std_logic_vector(TO_UNSIGNED(0, 7)) when 7,
        op1(23 downto 0) & std_logic_vector(TO_UNSIGNED(0, 8)) when 8,
        op1(22 downto 0) & std_logic_vector(TO_UNSIGNED(0, 9)) when 9,
        op1(21 downto 0) & std_logic_vector(TO_UNSIGNED(0, 10)) when 10,
        op1(20 downto 0) & std_logic_vector(TO_UNSIGNED(0, 11)) when 11,
        op1(19 downto 0) & std_logic_vector(TO_UNSIGNED(0, 12)) when 12,
        op1(18 downto 0) & std_logic_vector(TO_UNSIGNED(0, 13)) when 13,
        op1(17 downto 0) & std_logic_vector(TO_UNSIGNED(0, 14)) when 14,
        op1(16 downto 0) & std_logic_vector(TO_UNSIGNED(0, 15)) when 15,
        op1(15 downto 0) & std_logic_vector(TO_UNSIGNED(0, 16)) when 16,
        op1(14 downto 0) & std_logic_vector(TO_UNSIGNED(0, 17)) when 17,
        op1(13 downto 0) & std_logic_vector(TO_UNSIGNED(0, 18)) when 18,
        op1(12 downto 0) & std_logic_vector(TO_UNSIGNED(0, 19)) when 19,
        op1(11 downto 0) & std_logic_vector(TO_UNSIGNED(0, 20)) when 20,
        op1(10 downto 0) & std_logic_vector(TO_UNSIGNED(0, 21)) when 21,
        op1(9 downto 0) & std_logic_vector(TO_UNSIGNED(0, 22)) when 22,
        op1(8 downto 0) & std_logic_vector(TO_UNSIGNED(0, 23)) when 23,
        op1(7 downto 0) & std_logic_vector(TO_UNSIGNED(0, 24)) when 24,
        op1(6 downto 0) & std_logic_vector(TO_UNSIGNED(0, 25)) when 25,
        op1(5 downto 0) & std_logic_vector(TO_UNSIGNED(0, 26)) when 26,
        op1(4 downto 0) & std_logic_vector(TO_UNSIGNED(0, 27)) when 27,
        op1(3 downto 0) & std_logic_vector(TO_UNSIGNED(0, 28)) when 28,
        op1(2 downto 0) & std_logic_vector(TO_UNSIGNED(0, 29)) when 29,
        op1(1 downto 0) & std_logic_vector(TO_UNSIGNED(0, 30)) when 30,
        op1(0) & std_logic_vector(TO_UNSIGNED(0, 31)) when 31,
        std_logic_vector(TO_UNSIGNED(0, 32)) when others;
        
    with TO_INTEGER(unsigned(op2(5 downto 0))) select rsft <=
        op1(31 downto 0) when 0,
        std_logic_vector(TO_UNSIGNED(0, 1)) & op1(31 downto 1) when 1,
        std_logic_vector(TO_UNSIGNED(0, 2)) & op1(31 downto 2) when 2,
        std_logic_vector(TO_UNSIGNED(0, 3)) & op1(31 downto 3) when 3,
        std_logic_vector(TO_UNSIGNED(0, 4)) & op1(31 downto 4) when 4,
        std_logic_vector(TO_UNSIGNED(0, 5)) & op1(31 downto 5) when 5,
        std_logic_vector(TO_UNSIGNED(0, 6)) & op1(31 downto 6) when 6,
        std_logic_vector(TO_UNSIGNED(0, 7)) & op1(31 downto 7) when 7,
        std_logic_vector(TO_UNSIGNED(0, 8)) & op1(31 downto 8) when 8,
        std_logic_vector(TO_UNSIGNED(0, 9)) & op1(31 downto 9) when 9,
        std_logic_vector(TO_UNSIGNED(0, 10)) & op1(31 downto 10) when 10,
        std_logic_vector(TO_UNSIGNED(0, 11)) & op1(31 downto 11) when 11,
        std_logic_vector(TO_UNSIGNED(0, 12)) & op1(31 downto 12) when 12,
        std_logic_vector(TO_UNSIGNED(0, 13)) & op1(31 downto 13) when 13,
        std_logic_vector(TO_UNSIGNED(0, 14)) & op1(31 downto 14) when 14,
        std_logic_vector(TO_UNSIGNED(0, 15)) & op1(31 downto 15) when 15,
        std_logic_vector(TO_UNSIGNED(0, 16)) & op1(31 downto 16) when 16,
        std_logic_vector(TO_UNSIGNED(0, 17)) & op1(31 downto 17) when 17,
        std_logic_vector(TO_UNSIGNED(0, 18)) & op1(31 downto 18) when 18,
        std_logic_vector(TO_UNSIGNED(0, 19)) & op1(31 downto 19) when 19,
        std_logic_vector(TO_UNSIGNED(0, 20)) & op1(31 downto 20) when 20,
        std_logic_vector(TO_UNSIGNED(0, 21)) & op1(31 downto 21) when 21,
        std_logic_vector(TO_UNSIGNED(0, 22)) & op1(31 downto 22) when 22,
        std_logic_vector(TO_UNSIGNED(0, 23)) & op1(31 downto 23) when 23,
        std_logic_vector(TO_UNSIGNED(0, 24)) & op1(31 downto 24) when 24,
        std_logic_vector(TO_UNSIGNED(0, 25)) & op1(31 downto 25) when 25,
        std_logic_vector(TO_UNSIGNED(0, 26)) & op1(31 downto 26) when 26,
        std_logic_vector(TO_UNSIGNED(0, 27)) & op1(31 downto 27) when 27,
        std_logic_vector(TO_UNSIGNED(0, 28)) & op1(31 downto 28) when 28,
        std_logic_vector(TO_UNSIGNED(0, 29)) & op1(31 downto 29) when 29,
        std_logic_vector(TO_UNSIGNED(0, 30)) & op1(31 downto 30) when 30,
        std_logic_vector(TO_UNSIGNED(0, 31)) & op1(31) when 31,
        std_logic_vector(TO_UNSIGNED(0, 32)) when others;
        
        diff <= TO_SIGNED((TO_INTEGER(signed(op1)) - TO_INTEGER(signed(op2))), 33);
        with TO_INTEGER(diff) select eq <= '1' when 0, '0' when others;
        with diff(32) select lt <= '1' when '1', '0' when others;

end Behavioral;
