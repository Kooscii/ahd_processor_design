library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.math_real.all;


entity tb_cpu is
--  Port ( );
end tb_cpu;

architecture Behavioral of tb_cpu is

    component cpu is
        Port ( clk : in std_logic;
               rst : in std_logic;
               sw : in std_logic_vector (15 downto 0);
               led : out std_logic_vector (15 downto 0);
               btn : in std_logic_vector (4 downto 0);
               -- 7-seg
               seg : out std_logic_vector (6 downto 0);
               an : out std_logic_vector (3 downto 0);
               dp : out std_logic;
               -- inst update
               prog_addr : in std_logic_vector (9 downto 0);
               prog_wd : in std_logic_vector (31 downto 0);
               prog_clk : in std_logic;
               -- debug signal
               debug_0 : out std_logic_vector (31 downto 0);
               debug_1 : out std_logic_vector (31 downto 0)
               );
    end component;
    
    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal sw : std_logic_vector (15 downto 0);
    signal led : std_logic_vector (15 downto 0);
    signal btn : std_logic_vector (4 downto 0);
    -- 7-seg
    signal seg : std_logic_vector (6 downto 0);
    signal an : std_logic_vector (3 downto 0);
    signal dp : std_logic;
    -- inst update
    signal prog_addr : std_logic_vector (9 downto 0);
    signal prog_wd : std_logic_vector (31 downto 0);
    signal prog_clk : std_logic;
    -- debug signal
    signal debug_0 : std_logic_vector (31 downto 0);
    signal debug_1 : std_logic_vector (31 downto 0);
    
    constant clk_period : time := 10 ns;
    
    type PROG is array(0 to 255) of STD_LOGIC_VECTOR (31 downto 0);
    signal program : PROG := (
-- >>> start >>>
		x"04020064",
		x"00001810",
		x"28020003",
		x"00431810",
		x"00411011",
		x"30000002",
		x"0003f010",
		x"fc000007",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff"
-- <<< end <<<
    );
    
begin

    clk <= not clk after clk_period/2;
    
    UUT_cpu : cpu
        port map (
            clk => clk,
            rst => rst,
            sw => sw,
            led => led,
            btn => btn,
            -- 7-seg
            seg => seg,
            an => an,
            dp => dp,
            -- inst update
            prog_addr => prog_addr,
            prog_wd => prog_wd,
            prog_clk => prog_clk,
            debug_0 => debug_0,
            debug_1 => debug_1);
    
    process
    begin
        
        -- reseting
        rst <= '1';
        sw <= (others => '0');
        btn <= (others => '0');
        prog_addr <= (others => '0');
        prog_wd <= (others => '0');
        prog_clk <= '0';
        wait for 200ns;
        
        -- 1000 cases
        for i in 1 to 1000 loop
            -- doing some changes in your program
            -- example:
            -- program(5) = x"12345678";
            
            -- programing
            rst <= '1';
            for k in 0 to 255 loop
                prog_addr <= std_logic_vector( TO_UNSIGNED(k*4, 10));
                prog_wd <= program(k);
                
                wait for clk_period/2;
                prog_clk <= '1';
                wait for clk_period/2;
                prog_clk <= '0';
            end loop;
            
            -- running
            rst <= '0';
            prog_addr <= std_logic_vector( TO_UNSIGNED(0, 10));
            wait;
            
            -- assert here 
            -- assert condition
            --    report message
            --        severity failure;
       end loop;
        
    end process;


end Behavioral;