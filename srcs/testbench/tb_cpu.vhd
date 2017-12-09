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
		x"12c0ffff",
		x"1ad60010",
		x"12801946",
		x"16940010",
		x"12a05f91",
		x"02b5b012",
		x"0294a813",
		x"22800032",
		x"128051b2",
		x"16940010",
		x"12a041be",
		x"02b5b012",
		x"0294a813",
		x"22800033",
		x"128001a5",
		x"16940010",
		x"12a05563",
		x"02b5b012",
		x"0294a813",
		x"22800034",
		x"128091ce",
		x"16940010",
		x"12a0a910",
		x"02b5b012",
		x"0294a813",
		x"22800035",
		x"10400004",
		x"08420001",
		x"1d620032",
		x"2162001a",
		x"2c40fffc",
		x"1100b7e1",
		x"15080010",
		x"11085163",
		x"11209e37",
		x"15290010",
		x"112979b9",
		x"10680000",
		x"10400000",
		x"1080001a",
		x"20620000",
		x"00634810",
		x"04420001",
		x"2c44fffc",
		x"10400000",
		x"10600000",
		x"10800000",
		x"10a0004e",
		x"10c00000",
		x"10e00000",
		x"1280001f",
		x"12a0001a",
		x"12c00004",
		x"00c63810",
		x"1d020000",
		x"01064010",
		x"15280003",
		x"1908001d",
		x"00c94013",
		x"20c20000",
		x"00e63810",
		x"1d03001a",
		x"01074010",
		x"00f43812",
		x"09470020",
		x"01204013",
		x"11600000",
		x"29670003",
		x"15290001",
		x"056b0001",
		x"30000043",
		x"11600000",
		x"296a0003",
		x"19080001",
		x"096b0001",
		x"30000048",
		x"00e94013",
		x"20e3001a",
		x"04840001",
		x"04420001",
		x"04630001",
		x"2c550001",
		x"10400000",
		x"2c760001",
		x"10600000",
		x"2c85ffdf",
		x"12c0ffff",
		x"1ad60010",
		x"1280eedb",
		x"16940010",
		x"12a0a521",
		x"02b5b012",
		x"01f4a813",
		x"21e00028",
		x"12806d8f",
		x"16940010",
		x"12a04b15",
		x"02b5b012",
		x"0214a813",
		x"22000029",
		x"1280001f",
		x"1d000000",
		x"01ef4010",
		x"1d000001",
		x"02104010",
		x"10400001",
		x"1060000d",
		x"14820001",
		x"04a40001",
		x"01cf8012",
		x"01ce0014",
		x"11ae0000",
		x"01ce8012",
		x"01ce0014",
		x"01ad7812",
		x"01ad0014",
		x"010d7012",
		x"01080014",
		x"00f48012",
		x"09470020",
		x"01204013",
		x"11600000",
		x"29670003",
		x"15290001",
		x"056b0001",
		x"3000007a",
		x"11600000",
		x"296a0003",
		x"19080001",
		x"096b0001",
		x"3000007f",
		x"01294013",
		x"1d040000",
		x"01e84810",
		x"01cf8012",
		x"01ce0014",
		x"11ae0000",
		x"01ce8012",
		x"01ce0014",
		x"01ad7812",
		x"01ad0014",
		x"010d7012",
		x"01080014",
		x"00f47812",
		x"09470020",
		x"01204013",
		x"11600000",
		x"29670003",
		x"15290001",
		x"056b0001",
		x"30000093",
		x"11600000",
		x"296a0003",
		x"19080001",
		x"096b0001",
		x"30000098",
		x"01294013",
		x"1d050000",
		x"02084810",
		x"04420001",
		x"2462ffca",
		x"21e0002a",
		x"2200002b",
		x"1de0002a",
		x"1e00002b",
		x"1280001f",
		x"1040000c",
		x"14820001",
		x"04a40001",
		x"1d050000",
		x"01104011",
		x"00f47812",
		x"09470020",
		x"01204013",
		x"11600000",
		x"29670003",
		x"19290001",
		x"056b0001",
		x"300000af",
		x"11600000",
		x"296a0003",
		x"15080001",
		x"096b0001",
		x"300000b4",
		x"02084813",
		x"01cf8012",
		x"01ce0014",
		x"11ae0000",
		x"01ce8012",
		x"01ce0014",
		x"01ad7812",
		x"01ad0014",
		x"010d7012",
		x"02080014",
		x"1d040000",
		x"010f4011",
		x"00f48012",
		x"09470020",
		x"01204013",
		x"11600000",
		x"29670003",
		x"19290001",
		x"056b0001",
		x"300000c8",
		x"11600000",
		x"296a0003",
		x"15080001",
		x"096b0001",
		x"300000cd",
		x"01e84813",
		x"01cf8012",
		x"01ce0014",
		x"11ae0000",
		x"01ce8012",
		x"01ce0014",
		x"01ad7812",
		x"01ad0014",
		x"010d7012",
		x"01e80014",
		x"08420001",
		x"2c40ffca",
		x"1d000001",
		x"02104011",
		x"1d000000",
		x"01ef4011",
		x"21e0002c",
		x"2200002d",
		x"fc0000e3",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
		x"ffffffff",
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