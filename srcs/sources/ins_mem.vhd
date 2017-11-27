----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2017 07:51:14 PM
-- Design Name: 
-- Module Name: ins_mem - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ins_mem is
    Port ( inst : out STD_LOGIC_VECTOR (31 downto 0);
           addr : in STD_LOGIC_VECTOR (31 downto 0));
end ins_mem;

architecture Behavioral of ins_mem is
    type memory is array(0 to 7) of STD_LOGIC_VECTOR (31 downto 0); --can be changed later
    signal myMem: memory:= (
        X"00000001", 
        X"00000010",
        X"00000100", 
        X"00001000",
        X"00010000", 
        X"00100000",
        X"01000000", 
        X"10000000"
        );
begin
--	process(addr) 
--		subtype word is STD_LOGIC_VECTOR (31 downto 0);
--		type memory is array(0 to 7) of word;--can be changed later
--		variable myMem: memory:= (
--		    X"00000001", 
--		    X"00000010",
--			X"00000100", 
--			X"00001000",
--			X"00010000", 
--			X"00100000",
--			X"01000000", 
--			X"10000000"
--			);
--		begin
--			inst<=myMem(conv_integer(addr(31 downto 2)));
--		end process;

    inst<=myMem( TO_INTEGER( UNSIGNED( addr(31 downto 2))));
    
end Behavioral;


