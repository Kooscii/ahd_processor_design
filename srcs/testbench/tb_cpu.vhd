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
               prog_addr : in std_logic_vector (31 downto 0);
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
    signal prog_addr : std_logic_vector (31 downto 0);
    signal prog_wd : std_logic_vector (31 downto 0);
    signal prog_clk : std_logic;
    -- debug signal
    signal debug_0 : std_logic_vector (31 downto 0);
    signal debug_1 : std_logic_vector (31 downto 0);
    
    constant clk_period : time := 10 ns;
    
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
		x"101bffff",
		x"1bfc0010",
		x"2c1cfffe",
		x"02ffe012",
		x"2efc0001",
		x"3000003b",
		x"02dfe012",
		x"2edc0001",
		x"3000004d",
		x"02bfe012",
		x"2ebc0001",
		x"3000009e",
		x"029fe012",
		x"2e9c0001",
		x"300000dd",
		x"3000000e",
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
		x"3000005f",
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
		x"3000000c",
		x"10030003",
		x"10040004",
		x"02ffe012",
		x"2afcfffe",
		x"02ffe012",
		x"2efcfffe",
		x"001f5813",
		x"156b0010",
		x"02ffe012",
		x"2afcfffe",
		x"02ffe012",
		x"2efcfffe",
		x"033f5012",
		x"016a5013",
		x"206a0032",
		x"08630001",
		x"2c43fff1",
		x"3000005f",
		x"10030000",
		x"10040002",
		x"02dfe012",
		x"2adcfffe",
		x"02dfe012",
		x"2edcfffe",
		x"001f5813",
		x"156b0010",
		x"02dfe012",
		x"2adcfffe",
		x"02dfe012",
		x"2edcfffe",
		x"033f5012",
		x"016a5013",
		x"206a0036",
		x"04630001",
		x"2c83fff1",
		x"3000000c",
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
		x"3000000c",
		x"1c080036",
		x"1c090037",
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
		x"2008001e",
		x"2009001f",
		x"3000000c",
		x"1c080036",
		x"1c090037",
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
		x"20080020",
		x"20090021",
		x"3000000c",
		x"fc00011b",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
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
            for k in 0 to 511 loop
                prog_addr <= std_logic_vector( TO_UNSIGNED(k*4, 32));
                prog_wd <= program(k);
                
                wait for clk_period/2;
                prog_clk <= '1';
                wait for clk_period/2;
                prog_clk <= '0';
            end loop;
            
            -- running
            rst <= '0';
            prog_addr <= std_logic_vector( TO_UNSIGNED(0, 32));
            wait for 1 us;
            
            -- input ukey
            
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;           
            
            sw <= x"91ce";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
            sw <= x"a910";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
                        
            sw <= x"01a5";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
            sw <= x"5563";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
            
            sw <= x"51b2";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
            sw <= x"41be";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
                          
            sw <= x"1946";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
            sw <= x"5f91";
            btn(3) <= '1';
            wait for 1 us;
            btn(3) <= '0';
            wait for 1 us;
            
            -- wait for key expansion
            wait for 100 us;
            
            -- input din
                       
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;           
            
            sw <= x"eedb";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
            sw <= x"a521";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
                       
            sw <= x"6d8f";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
            sw <= x"4b15";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
            
            -- encryption
            btn(1) <= '1';
            wait for 1 us;
            btn(1) <= '0';
            wait for 1 us;
            
            wait for 30 us;
            
            -- input din
                                   
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;           
            
            sw <= x"ac13";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
            sw <= x"c0f7";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
                       
            sw <= x"5289";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
            sw <= x"2b5b";
            btn(2) <= '1';
            wait for 1 us;
            btn(2) <= '0';
            wait for 1 us;
            
            -- decryption
            btn(0) <= '1';
            wait for 1 us;
            btn(0) <= '0';
            wait for 1 us;
               
            wait;
            
       end loop;
        
    end process;


end Behavioral;