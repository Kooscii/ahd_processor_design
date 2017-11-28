----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2017 07:51:14 PM
-- Design Name: 
-- Module Name: ctrl_unit - Behavioral
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

entity ctrl_unit is
    Port ( lw : out STD_LOGIC;
           sw : out STD_LOGIC;
           branch : out STD_LOGIC;
           bnc_type : out STD_LOGIC_VECTOR (1 downto 0);
           jump : out STD_LOGIC;
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           op2src : out STD_LOGIC;
           regdst : out STD_LOGIC;
           regwrt : out STD_LOGIC;
           inst : in STD_LOGIC_VECTOR (31 downto 0));
end ctrl_unit;

architecture Behavioral of ctrl_unit is

begin
    
    process(inst) is
    begin
        case inst(31 downto 26) is
            when "000000" => --ADD or SUB or AND or OR or NOR
                funct(2 downto 0) <= inst(2 downto 0);   -- when default value is changed, it is in the first paragraph, default values are in the second paragraph
                regdst <= '1';
                regwrt <= '1';
                
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                op2src <= '0';
                bnc_type <= "00";
            
            when "000001" => --ADDI
                funct(2 downto 0) <= "000";
                op2src <= '1';
                regwrt <= '1';
            
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                regdst <= '0';
                bnc_type <= "00";
            
            when "000010" => --SUBI
                funct(2 downto 0) <= "001";
                op2src <= '1';
                regwrt <= '1';
            
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                regdst <= '0';
                bnc_type <= "00";
            
            when "000011" => --ANDI
                funct(2 downto 0) <= "010";
                op2src <= '1';
                regwrt <= '1';
            
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                regdst <= '0';
                bnc_type <= "00";
            
            when "000100" => --ORI
                funct(2 downto 0) <= "011";
                op2src <= '1';
                regwrt <= '1';
            
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                regdst <= '0';
                bnc_type <= "00";
            
            when "000101" => --SHL
                funct(2 downto 0) <= "101";
                op2src <= '1';
                regwrt <= '1';
            
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                regdst <= '0';
                bnc_type <= "00";
            
            when "000110" => --SHR
                funct(2 downto 0) <= "110";
                op2src <= '1';
                regwrt <= '1';
            
                lw <= '0';
                sw <= '0';
                branch <= '0';
                jump <= '0';
                regdst <= '0';
                bnc_type <= "00";
            
            when "000111" => --LW
                lw <= '1';
                op2src <= '1';
                regwrt <= '1';
                
                sw <= '0';
                branch <= '0';
                jump <= '0';
                funct <= "000";
                regdst <= '0';
                bnc_type <= "00";
            
            when "001000" => --SW
                sw <= '1';
                op2src <= '1';
                
                lw <= '0';
                branch <= '0';
                jump <= '0';
                funct <= "000";
                regdst <= '0';
                regwrt <= '0';
                bnc_type <= "00";
                
            when "001001" => --BLT
                branch <= '1';

                op2src <= '0';
                lw <= '0';
                sw <= '0';
                jump <= '0';
                funct <= "000";
                regdst <= '0';
                regwrt <= '0';
                bnc_type <= "10";
                
            when "001010" => --BEQ
                branch <= '1';

                op2src <= '0';
                lw <= '0';
                sw <= '0';
                jump <= '0';
                funct <= "000";
                regdst <= '0';
                regwrt <= '0';
                bnc_type <= "11";
                
            when "001011" => --BNE
                branch <= '1';

                op2src <= '0';
                lw <= '0';
                sw <= '0';
                jump <= '0';
                funct <= "000";
                regdst <= '0';
                regwrt <= '0';
                bnc_type <= "01";
                
            when "001100" => --JMP
                jump <= '1';
                
                lw <= '0';
                sw <= '0';
                branch <= '0';
                funct <= "000";
                op2src <= '0';
                regdst <= '0';
                regwrt <= '0';
                bnc_type <= "00";
            
            when others => --HALT
                jump <= '1';
                branch <= '1';

                lw <= '0';
                sw <= '0';
                funct <= "000";
                op2src <= '0';
                regdst <= '0';
                regwrt <= '0';
                bnc_type <= "00";
                
        end case;
    end process;

end Behavioral;
