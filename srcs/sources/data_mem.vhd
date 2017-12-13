----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:40:30 11/27/2017 
-- Design Name: 
-- Module Name:    data_mem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;
---WARNING:Xst:647 - Input <addr<1:0>> is never used. 
-----This port will be preserved and left unconnected if it belongs to 
----------a top-level block or it belongs to a sub-block 
------------------and the hierarchy of this sub-block is preserved.
---WARNING:Xst:647 - Input <addr<31:9>> is never used. 
-----This port will be preserved and left unconnected if it belongs to 
----------a top-level block or it belongs to a sub-block
------------------and the hierarchy of this sub-block is preserved.


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_mem is
    Port ( rd : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           wd : in STD_LOGIC_VECTOR (31 downto 0));
end data_mem;

architecture Behavioral of data_mem is

-------------------------------------------------------
----			 DATA MEMORY								    ---
-------------------------------------------------------
---Yiren DAI(yd1257)'s comments and questions:
---I don't have a solid knowledge of Data Memory. If I understand is question
---wrongly, I apologize for that...
---My understanding of the Data Memory is a 128 rows * 32 cols matrix.
---For the 32 cols(32 bits), we allocated them into 4 combined columns, each part
---is a 8-bits byte
---For the 128 rows, we use addr to select which row we want
---???addr have 32 bits, I think 7 bits is enough to represent 128 rows(2^7 = 128)

type DATA_MEMORY is array(0 to 127) of std_logic_vector(31 downto 0);

-------------------------------------------------------
----			ASSIGN DATA MEMORY TO SIGNAL			   ----
-------------------------------------------------------
signal data_mem : DATA_MEMORY := (others=>std_logic_vector(TO_UNSIGNED(0, 32)));

-------------------------------------------------------
----			INTERNAL DECLARATION						   ----
-------------------------------------------------------
---Yiren DAI(yd1257)'s comments and questions:
---I created this signal to receive the 8 downto 2 (7 digits) from addr

begin

---Updted on Nov 28, 2017:
---1)Based on Tianyu's instruction, I changed the sig_addr from addr(6 downto 0)
---  to addr(8 downto 2)
---2)Fengyang taught me why I need (8 downto 2) but NOT (6 downto 0), I am more 
---  clear now but still NOT 100% understand

   
	process (clk, rst)
	begin
	  ---Reset all to 0x0 when rst is HIGH
	  if (rst = '1')  then
	  ---Reading data is asynchronous, rd = MEM[addr:addr+4].
			data_mem <= (OTHERS => std_logic_vector(TO_UNSIGNED(0, 32)));
	  elsif rising_edge(clk) then 
			if we = '1' then
				data_mem(TO_INTEGER(unsigned(addr(6 downto 0)))) <= wd;
			end if;
	  end if;
	  
--	  rd <= data_mem(TO_INTEGER(unsigned(addr(6 downto 0))));
	end process;
	
rd <= data_mem(TO_INTEGER(unsigned(addr(6 downto 0))));
	
end Behavioral;

