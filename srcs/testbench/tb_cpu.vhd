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
               cpu_rst : in std_logic;
               sw : in std_logic_vector (15 downto 0);
               led : out std_logic_vector (15 downto 0);
               btn : in std_logic_vector (4 downto 0);
               -- 7-seg
               seg : out std_logic_vector (6 downto 0);
               an : out std_logic_vector (7 downto 0);
               dp : out std_logic;
               tx : out std_logic;
               rx : in std_logic
--               -- inst update
--               prog_addr : in std_logic_vector (31 downto 0);
--               prog_wd : in std_logic_vector (31 downto 0);
--               prog_clk : in std_logic;
--               -- debug signal
--               debug_0 : out std_logic_vector (31 downto 0);
--               debug_1 : out std_logic_vector (31 downto 0)
               );
    end component;
    
    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal sw : std_logic_vector (15 downto 0);
    signal led : std_logic_vector (15 downto 0);
    signal btn : std_logic_vector (4 downto 0);
    -- 7-seg
    signal seg : std_logic_vector (6 downto 0);
    signal an : std_logic_vector (7 downto 0);
    signal dp : std_logic;
    signal tx : std_logic := '0';
    signal rx : std_logic;
    -- inst update
    signal prog_addr : std_logic_vector (31 downto 0);
    signal prog_wd : std_logic_vector (31 downto 0);
    signal prog_clk : std_logic;
    -- debug signal
    signal debug_0 : std_logic_vector (31 downto 0);
    signal debug_1 : std_logic_vector (31 downto 0);
    
    constant clk_period : time := 40 ns;
    
    type PROG is array(0 to 511) of STD_LOGIC_VECTOR (31 downto 0);
    signal program : PROG := (
-- >>> start >>>
		x"00000011",
		x"10010001",
		x"1002ffff",
		x"14340010",
		x"16950001",
		x"16b60001",
		x"16d70001",
		x"16f80001",
		x"1019ffff",
		x"1b390010",
		x"101a001f",
		x"173b0010",
		x"10030008",
		x"10040100",
		x"18840001",
		x"08630001",
		x"2064005a",
		x"2c03fffc",
		x"10130001",
		x"10120000",
		x"1bfc0010",
		x"2c1cfffe",
		x"101d0000",
		x"10110005",
		x"0253f013",
		x"02dfe012",
		x"2edc0006",
		x"0a730001",
		x"2c130001",
		x"0a330001",
		x"0253f013",
		x"02dfe012",
		x"2adcfffe",
		x"02ffe012",
		x"2efc0006",
		x"06730001",
		x"2e330001",
		x"04130001",
		x"0253f013",
		x"02ffe012",
		x"2afcfffe",
		x"029fe012",
		x"2e9c000c",
		x"100a0001",
		x"2d530001",
		x"30000038",
		x"100a0002",
		x"2d530001",
		x"30000067",
		x"100a0003",
		x"2d530001",
		x"300000d7",
		x"100a0004",
		x"2d530001",
		x"30000124",
		x"30000018",
		x"1bfc0010",
		x"2c1cfffe",
		x"10030007",
		x"100d0007",
		x"10110000",
		x"033f5812",
		x"156b0010",
		x"1c6a003c",
		x"016af013",
		x"1c7d005a",
		x"023fe012",
		x"2c1cfffe",
		x"10110000",
		x"02dfe012",
		x"2edc0004",
		x"29a30001",
		x"04630001",
		x"12d10000",
		x"3000003d",
		x"02ffe012",
		x"2efc0004",
		x"28030001",
		x"08630001",
		x"12f10000",
		x"3000003d",
		x"029fe012",
		x"2e9c0004",
		x"033f5012",
		x"206a003c",
		x"12910000",
		x"3000003d",
		x"031fe012",
		x"2f1c0001",
		x"3000005b",
		x"3000003d",
		x"10030003",
		x"14640001",
		x"04850001",
		x"1cab003c",
		x"156b0010",
		x"1c8a003c",
		x"032a5012",
		x"016a5013",
		x"206a0032",
		x"08630001",
		x"2c43fff6",
		x"30000096",
		x"1bfc0010",
		x"2c1cfffe",
		x"10030003",
		x"100d0003",
		x"10110000",
		x"033f5812",
		x"156b0010",
		x"1c6a0046",
		x"016af013",
		x"1c7d005a",
		x"023fe012",
		x"2c1cfffe",
		x"10110000",
		x"02dfe012",
		x"2edc0004",
		x"29a30001",
		x"04630001",
		x"12d10000",
		x"3000006c",
		x"02ffe012",
		x"2efc0004",
		x"28030001",
		x"08630001",
		x"12f10000",
		x"3000006c",
		x"029fe012",
		x"2e9c0004",
		x"033f5012",
		x"206a0046",
		x"12910000",
		x"3000006c",
		x"031fe012",
		x"2f1c0001",
		x"3000008a",
		x"3000006c",
		x"10030001",
		x"14640001",
		x"04850001",
		x"1cab0046",
		x"156b0010",
		x"1c8a0046",
		x"032a5012",
		x"016a5013",
		x"206a0036",
		x"08630001",
		x"2c43fff6",
		x"30000014",
		x"10030003",
		x"1c6a0032",
		x"206a001a",
		x"08630001",
		x"2443fffc",
		x"100bb7e1",
		x"156b0010",
		x"0f2a5163",
		x"016a4013",
		x"100b9e37",
		x"156b0010",
		x"0f2a79b9",
		x"016a4813",
		x"11070000",
		x"20070000",
		x"10030001",
		x"1004001a",
		x"00e93810",
		x"20670000",
		x"04630001",
		x"2464fffc",
		x"10030000",
		x"10040000",
		x"10050000",
		x"100d001a",
		x"100e0004",
		x"100f004e",
		x"10080000",
		x"10090000",
		x"01094010",
		x"1c670000",
		x"00e83810",
		x"14eb0003",
		x"18ea001d",
		x"016a4013",
		x"20680000",
		x"01094810",
		x"1c87001a",
		x"00e93810",
		x"10060000",
		x"03498012",
		x"00075813",
		x"28000002",
		x"156b0001",
		x"04c60001",
		x"24d0fffd",
		x"10100020",
		x"00075013",
		x"28000002",
		x"194a0001",
		x"04c60001",
		x"24d0fffd",
		x"016a4813",
		x"2089001a",
		x"04630001",
		x"04840001",
		x"246d0001",
		x"10030000",
		x"248e0001",
		x"10040000",
		x"04a50001",
		x"24afffdf",
		x"10128888",
		x"16520010",
		x"30000014",
		x"1c080037",
		x"1c090036",
		x"1c070000",
		x"01074010",
		x"1c070001",
		x"01274810",
		x"10030001",
		x"100d000d",
		x"14640001",
		x"04850001",
		x"01095812",
		x"01605814",
		x"116a0000",
		x"01695812",
		x"01605814",
		x"01485012",
		x"01405014",
		x"016a5012",
		x"01405014",
		x"014a5813",
		x"10060000",
		x"03498012",
		x"28000002",
		x"156b0001",
		x"04c60001",
		x"24d0fffd",
		x"10100020",
		x"28000002",
		x"194a0001",
		x"04c60001",
		x"24d0fffd",
		x"016a5013",
		x"1c870000",
		x"01474010",
		x"01095812",
		x"01605814",
		x"116a0000",
		x"01695812",
		x"01605814",
		x"01485012",
		x"01405014",
		x"016a5012",
		x"01405014",
		x"014a5813",
		x"10060000",
		x"03488012",
		x"28000002",
		x"156b0001",
		x"04c60001",
		x"24d0fffd",
		x"10100020",
		x"28000002",
		x"194a0001",
		x"04c60001",
		x"24d0fffd",
		x"016a5013",
		x"1ca70000",
		x"01474810",
		x"04630001",
		x"2da3ffcc",
		x"2008001f",
		x"2009001e",
		x"1c1e001f",
		x"1c3d005a",
		x"1bfc0010",
		x"2c1cfffe",
		x"02dfe012",
		x"2edc0002",
		x"1c1e001f",
		x"1c3d005a",
		x"02ffe012",
		x"2efc0002",
		x"1c1e001e",
		x"1c1d005a",
		x"031fe012",
		x"2f1cfff6",
		x"30000014",
		x"1c080037",
		x"1c090036",
		x"1003000c",
		x"14640001",
		x"04850001",
		x"1ca70000",
		x"01275011",
		x"014a5813",
		x"10060000",
		x"03488012",
		x"28000002",
		x"194a0001",
		x"04c60001",
		x"24d0fffd",
		x"10100020",
		x"28000002",
		x"156b0001",
		x"04c60001",
		x"24d0fffd",
		x"016a4813",
		x"01095812",
		x"01605814",
		x"116a0000",
		x"01695812",
		x"01605814",
		x"01485012",
		x"01405014",
		x"016a5012",
		x"01404814",
		x"1c870000",
		x"01075011",
		x"014a5813",
		x"10060000",
		x"03498012",
		x"28000002",
		x"194a0001",
		x"04c60001",
		x"24d0fffd",
		x"10100020",
		x"28000002",
		x"156b0001",
		x"04c60001",
		x"24d0fffd",
		x"016a4013",
		x"01095812",
		x"01605814",
		x"116a0000",
		x"01695812",
		x"01605814",
		x"01485012",
		x"01405014",
		x"016a5012",
		x"01404014",
		x"08630001",
		x"2c03ffcc",
		x"1c070001",
		x"01274811",
		x"1c070000",
		x"01074011",
		x"20080021",
		x"20090020",
		x"1c1e0021",
		x"1c3d005a",
		x"1bfc0010",
		x"2c1cfffe",
		x"02dfe012",
		x"2edc0002",
		x"1c1e0021",
		x"1c3d005a",
		x"02ffe012",
		x"2efc0002",
		x"1c1e0020",
		x"1c1d005a",
		x"031fe012",
		x"2f1cfff6",
		x"30000014",
		x"100b1946",
		x"156b0010",
		x"0f2a5f91",
		x"016a5013",
		x"200a0032",
		x"100b51b2",
		x"156b0010",
		x"0f2a41be",
		x"016a5013",
		x"200a0033",
		x"100b01a5",
		x"156b0010",
		x"0f2a5563",
		x"016a5013",
		x"200a0034",
		x"100b91ce",
		x"156b0010",
		x"0f2aa910",
		x"016a5013",
		x"200a0035",
		x"30000096",
		x"100beedb",
		x"156b0010",
		x"0f2aa521",
		x"016a5013",
		x"200a0036",
		x"100b6d8f",
		x"156b0010",
		x"0f2a4b15",
		x"016a5013",
		x"200a0037",
		x"30000014",
		x"fc000190",
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

    clk <= not clk after clk_period/8;
    
    UUT_cpu : cpu
        port map (
            clk => clk,
            cpu_rst => rst,
            sw => sw,
            led => led,
            btn => btn,
            -- 7-seg
            seg => seg,
            an => an,
            dp => dp,
            tx => tx,
            rx => rx);
--            -- inst update
--            prog_addr => prog_addr,
--            prog_wd => prog_wd,
--            prog_clk => prog_clk,
--            debug_0 => debug_0,
--            debug_1 => debug_1);
    
    process
    begin
        
        -- reseting
        rst <= '0';
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
            
--            -- programing
--            rst <= '1';
--            for k in 0 to 511 loop
--                prog_addr <= std_logic_vector( TO_UNSIGNED(k*4, 32));
--                prog_wd <= program(k);
                
--                wait for clk_period/2;
--                prog_clk <= '1';
--                wait for clk_period/2;
--                prog_clk <= '0';
--            end loop;
            
            -- running
            rst <= '1';
            prog_addr <= std_logic_vector( TO_UNSIGNED(0, 32));
            wait for 5 us;
            
            -- input ukey
            
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;           
            
--            sw <= x"91ce";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
--            sw <= x"a910";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
                        
--            sw <= x"01a5";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
--            sw <= x"5563";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
            
--            sw <= x"51b2";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
--            sw <= x"41be";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
                          
--            sw <= x"1946";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
--            sw <= x"5f91";
            sw <= x"0000";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
            
            -- wait for key expansion
            btn(4) <= '1'; wait for 1 us; btn(4) <= '0'; wait for 1 us;
            wait for 500 us;
            
            -- input din
                       
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;         
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;
            
--            sw <= x"eedb";
            sw <= x"2d00";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
--            sw <= x"a521";
            sw <= x"fca6";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
                       
--            sw <= x"6d8f";
            sw <= x"258f";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
--            sw <= x"4b15";
            sw <= x"4cd8";
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us; 
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us;
            
            btn(4) <= '1'; wait for 1 us; btn(4) <= '0'; wait for 1 us;
            
            -- encryption
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us; 
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;
            wait for 150 us;
            
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;
           
            -- decryption
            btn(3) <= '1'; wait for 1 us; btn(3) <= '0'; wait for 1 us; 
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;
            wait for 150 us;
            
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;
            btn(0) <= '1'; wait for 1 us; btn(0) <= '0'; wait for 1 us;

            
            wait;
            
       end loop;
        
    end process;


end Behavioral;