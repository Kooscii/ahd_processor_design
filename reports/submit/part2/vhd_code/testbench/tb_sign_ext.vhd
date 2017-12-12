library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;


entity tb_sign_ext is
--  Port ( );
end tb_sign_ext;

architecture Behavioral of tb_sign_ext is

    component sign_ext is
        port ( imm32 : out std_logic_vector (31 downto 0);
               imm16 : in std_logic_vector (15 downto 0));
    end component;
    
    signal imm32 : std_logic_vector (31 downto 0);
    signal imm16 : std_logic_vector (15 downto 0);
    type test_stage is (TESTING, FINISHED);
    signal stage : test_stage := TESTING;
    
begin

    DUT_sign_ext : sign_ext 
        port map ( imm32 => imm32, 
                   imm16 => imm16);
    
    testbench : process
        variable seed1 : positive; 
        variable seed2 : positive;
        variable rand : real;
        variable rand_range : real := 65536.0;
        variable rand_offset : integer := -32768;
    begin
        -- 1000 random cases
        for k in 1 to 1000 loop
            uniform(seed1, seed2, rand);
            imm16 <=  std_logic_vector(TO_SIGNED(integer(trunc(rand*rand_range))+rand_offset, 16));
            
            wait for 10ns; 
            
            assert TO_INTEGER(signed(imm16)) = TO_INTEGER(signed(imm32))
                report "Wrong sign extension: " & integer'image(TO_INTEGER(signed(imm16))) & " to " & integer'image(TO_INTEGER(signed(imm32)))
                    severity failure;
        end loop;
        
        stage <= FINISHED;
        report "1000 cases passed.";
        
        wait;
    
    end process;
    
end Behavioral;