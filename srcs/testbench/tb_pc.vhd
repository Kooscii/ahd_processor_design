library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;


entity tb_pc is
--  Port ( );
end tb_pc;

architecture Behavioral of tb_pc is

    component pc_unit is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               branch : in STD_LOGIC;
               condi : in STD_LOGIC;
               jump : in STD_LOGIC;
               offset : in STD_LOGIC_VECTOR (31 downto 0);
               addr : in STD_LOGIC_VECTOR (25 downto 0);
               pc_next : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC;
    signal branch : STD_LOGIC;
    signal condi : STD_LOGIC;
    signal jump : STD_LOGIC;
    signal offset : STD_LOGIC_VECTOR (31 downto 0);
    signal addr : STD_LOGIC_VECTOR (25 downto 0);
    signal pc_next : STD_LOGIC_VECTOR (31 downto 0);
    
    signal pc : unsigned (31 downto 0);
    
    constant clk_period : time := 10ns;
    
    type test_stage is (TESTING1, TESTING2, TESTING3, TESTING4, FINISHED);
    signal stage : test_stage := TESTING1;
    
begin

    UUT_pc : pc_unit
        Port map ( 
            clk => clk,
            rst => rst,
            branch => branch,
            condi => condi,
            jump => jump,
            offset => offset,
            addr => addr,
            pc_next => pc_next);
            
    clk <= not clk after clk_period/2;
            
    testbench : process
        variable seed1 : positive; 
        variable seed2 : positive;
        variable rand : real;
    begin
    
    
        rst <= '1';
        wait for clk_period*10;
        
        rst <= '0';
        branch <= '0';
        condi <= '0';
        jump <= '0';
        offset <= (others=>'0');
        addr <= (others=>'0');
        pc <= (others=>'0');
        -- 1000 clk for continuously increasing 
        stage <= TESTING1;
        for k in 0 to 999 loop
            assert pc_next = std_logic_vector(TO_UNSIGNED(k*4, 32))
                report "Wrong pc"
                    severity failure;
                    
            wait for clk_period; 
        end loop;
        
        -- 1000 cases for branch
        stage <= TESTING2;
        branch <= '1';
        condi <= '1';
        for k in 0 to 1000 loop
            -- generate a random 16-bit signed vector in range [-2**15, 2**15)
            uniform(seed1, seed2, rand);        
            offset <= std_logic_vector(TO_SIGNED(integer(trunc(rand*65536.0))-32768, 32));
            -- pc <= pc + 4
            pc <= unsigned(pc_next) + 4;
            wait for clk_period; 
            -- check if pc_next == pc + 4 + offset<<2
            assert pc_next = std_logic_vector(signed(pc)+(signed(offset) sll 2))
                report "Wrong pc"
                    severity failure;
        end loop;
        
        -- 1000 cases for jump
        stage <= TESTING3;
        branch <= '0';
        condi <= '0';
        jump <= '1';
        offset <= (others=>'0');
        for k in 0 to 1000 loop
            uniform(seed1, seed2, rand);
            addr <= std_logic_vector(TO_SIGNED(integer(trunc(rand*67108864.0))-33554432, 26));
            pc <= unsigned(pc_next) + 4;
            
            wait for clk_period; 
            
            assert pc_next = std_logic_vector(pc(31 downto 28)) & addr & "00"
                report "Wrong pc"
                    severity failure;
        end loop;
        
        -- halt
        stage <= TESTING4;
        branch <= '1';
        jump <= '1';
        addr <= (others=>'0');
        for k in 0 to 100 loop
            pc <= unsigned(pc_next);
            
            wait for clk_period; 
            
            assert pc_next = std_logic_vector(pc)
                report "Wrong pc"
                    severity failure;
        end loop;
        
        stage <= FINISHED;
        report "Testbench passed.";
        
        wait;
    
    end process;
    
end Behavioral;