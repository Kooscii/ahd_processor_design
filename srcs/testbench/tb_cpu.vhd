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
		x"10000000",
		x"10200001",
		x"1040ffff",
		x"16810010",
		x"16b40001",
		x"16d50001",
		x"16f60001",
		x"17170001",
		x"1320ffff",
		x"1b390010",
		x"1340001f",
		x"1360ffff",
		x"1b9f0010",
		x"2f80fffe",
		x"0397f812",
		x"2f970001",
		x"3000001b",
		x"0396f812",
		x"2f960001",
		x"3000002d",
		x"0395f812",
		x"2f950001",
		x"3000000c",
		x"0394f812",
		x"2f940001",
		x"3000000c",
		x"3000000c",
		x"10600000",
		x"10800004",
		x"0394f812",
		x"2b94fffe",
		x"0394f812",
		x"2f94fffe",
		x"0160f813",
		x"156b0010",
		x"0394f812",
		x"2b94fffe",
		x"0394f812",
		x"2f94fffe",
		x"0159f812",
		x"014b5013",
		x"21420032",
		x"04630001",
		x"2c64fff1",
		x"3000003f",
		x"10600000",
		x"10800002",
		x"0394f812",
		x"2b94fffe",
		x"0394f812",
		x"2f94fffe",
		x"0160f813",
		x"156b0010",
		x"0394f812",
		x"2b94fffe",
		x"0394f812",
		x"2f94fffe",
		x"0159f812",
		x"014b5013",
		x"21420036",
		x"04630001",
		x"2c64fff1",
		x"3000000c",
		x"10600003",
		x"1d430032",
		x"2143001a",
		x"08630001",
		x"2462fffc",
		x"1160b7e1",
		x"156b0010",
		x"0d595163",
		x"010b5013",
		x"11609e37",
		x"156b0010",
		x"0d5979b9",
		x"012b5013",
		x"10e80000",
		x"20620000",
		x"10600001",
		x"1080001a",
		x"00e74810",
		x"20e30000",
		x"04630001",
		x"2483fffc",
		x"10600000",
		x"10800000",
		x"10a00000",
		x"11a0001a",
		x"11c00004",
		x"11e0004e",
		x"1100001a",
		x"11200004",
		x"01084810",
		x"1ce30000",
		x"00e74010",
		x"15670003",
		x"1947001d",
		x"010b5013",
		x"21030000",
		x"01284810",
		x"1ce4001a",
		x"00e74810",
		x"10c00000",
		x"021a4812",
		x"01603813",
		x"3000006c",
		x"156b0001",
		x"04c60001",
		x"2606fffd",
		x"12000020",
		x"01403813",
		x"30000072",
		x"194a0001",
		x"04c60001",
		x"2606fffd",
		x"012b5013",
		x"2124001a",
		x"04630001",
		x"04840001",
		x"25a30001",
		x"10600000",
		x"25c40001",
		x"10800000",
		x"04a50001",
		x"25e5ffdf",
		x"3000000c",
		x"1de00028",
		x"1e000029",
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
		x"30000096",
		x"11600000",
		x"296a0003",
		x"19080001",
		x"096b0001",
		x"3000009b",
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
		x"300000af",
		x"11600000",
		x"296a0003",
		x"19080001",
		x"096b0001",
		x"300000b4",
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
		x"300000cb",
		x"11600000",
		x"296a0003",
		x"15080001",
		x"096b0001",
		x"300000d0",
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
		x"300000e4",
		x"11600000",
		x"296a0003",
		x"15080001",
		x"096b0001",
		x"300000e9",
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
		x"fc0000ff"
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