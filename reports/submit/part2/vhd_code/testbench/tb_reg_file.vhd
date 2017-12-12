library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

entity tb_reg_file is
end tb_reg_file;


architecture Behavioral of tb_reg_file is

    component reg_file is
        port ( rd1 : out STD_LOGIC_VECTOR (31 downto 0);
               rd2 : out STD_LOGIC_VECTOR (31 downto 0);
               clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               we : in STD_LOGIC;
               rs : in STD_LOGIC_VECTOR (4 downto 0);
               rt : in STD_LOGIC_VECTOR (4 downto 0);
               rd : in STD_LOGIC_VECTOR (4 downto 0);
               wd : in STD_LOGIC_VECTOR (31 downto 0);
               r31 : in STD_LOGIC_VECTOR (31 downto 0); -- btn & sw read-only
               r30 : out STD_LOGIC_VECTOR (31 downto 0); -- 7-seg display
               r29 : out STD_LOGIC_VECTOR (31 downto 0) -- led display
               );
    end component;
    
    signal rd1 : STD_LOGIC_VECTOR (31 downto 0);
    signal rd2 : STD_LOGIC_VECTOR (31 downto 0);
    signal clk : STD_LOGIC;
    signal rst : STD_LOGIC;
    signal we : STD_LOGIC;
    signal rs : STD_LOGIC_VECTOR (4 downto 0);
    signal rt : STD_LOGIC_VECTOR (4 downto 0);
    signal rd : STD_LOGIC_VECTOR (4 downto 0);
    signal wd : STD_LOGIC_VECTOR (31 downto 0);
    signal r31 : STD_LOGIC_VECTOR (31 downto 0);
    signal r30 : STD_LOGIC_VECTOR (31 downto 0);
    signal r29 : STD_LOGIC_VECTOR (31 downto 0);
    
    type test_stage is (TESTING, FINISHED);
    signal stage : test_stage := TESTING;
    
    constant clk_period : time := 40 ns;

begin

    RF: reg_file port map (rd1 => rd1, rd2 => rd2, clk => clk, rst => rst, we => we,
                           rs => rs, rt => rt, rd => rd, wd => wd, r31 => r31, r30 => r30, r29 => r29);
    
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    testbench : process
        variable seed1 : positive; 
        variable seed2 : positive;
        variable rand : real;
        variable rand_range : real := 2147483648.0;
        variable rand_offset : integer := -1073741824;
    
    begin
        rst <= '1';
        wait for 5 * clk_period;
        rst <= '0';
        wait for 2 * clk_period;
        
        for i in 0 to 30 loop
            rs <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 5));
            rt <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 5));
            rd <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 5));
            wait for clk_period;
            
            for j in 1 to 1000 loop
                uniform(seed1, seed2, rand);
                wd <=  STD_LOGIC_VECTOR(TO_SIGNED(integer(trunc(rand*rand_range))+rand_offset, 32));
                we <= '1';
                wait for clk_period;
                we <= '0';
                wait for clk_period;
                
                assert (rd1 = wd)
                    report "Wrong"
                        severity failure;
                assert (rd2 = wd)
                    report "Wrong"
                        severity failure;
                
                wait for clk_period;
            end loop;
        end loop;
        
        stage <= FINISHED;
        report "1000*31=31000 cases passed.";
        
        wait;
        
    end process;

end Behavioral;