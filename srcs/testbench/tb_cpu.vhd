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
		x"1016ffff",
		x"1ad60010",
		x"10141946",
		x"16940010",
		x"10155f91",
		x"02b6a812",
		x"0295a013",
		x"20140032",
		x"101451b2",
		x"16940010",
		x"101541be",
		x"02b6a812",
		x"0295a013",
		x"20140033",
		x"101401a5",
		x"16940010",
		x"10155563",
		x"02b6a812",
		x"0295a013",
		x"20140034",
		x"101491ce",
		x"16940010",
		x"1015a910",
		x"02b6a812",
		x"0295a013",
		x"20140035",
		x"10020004",
		x"08420001",
		x"1c4b0032",
		x"204b001a",
		x"2c02fffc",
		x"1008b7e1",
		x"15080010",
		x"11085163",
		x"10099e37",
		x"15290010",
		x"112979b9",
		x"11030000",
		x"10020000",
		x"1004001a",
		x"20430000",
		x"00691810",
		x"04420001",
		x"2c82fffc",
		x"10020000",
		x"10030000",
		x"10040000",
		x"1005004e",
		x"10060000",
		x"10070000",
		x"1014001f",
		x"1015001a",
		x"10160004",
		x"00c73010",
		x"1c480000",
		x"00c84010",
		x"15090003",
		x"1908001d",
		x"01283013",
		x"20460000",
		x"00c73810",
		x"1c68001a",
		x"00e84010",
		x"02873812",
		x"08ea0020",
		x"00084813",
		x"100b0000",
		x"28eb0003",
		x"15290001",
		x"056b0001",
		x"30000043",
		x"100b0000",
		x"294b0003",
		x"19080001",
		x"096b0001",
		x"30000048",
		x"01283813",
		x"2067001a",
		x"04840001",
		x"04420001",
		x"04630001",
		x"2ea20001",
		x"10020000",
		x"2ec30001",
		x"10030000",
		x"2ca4ffdf",
		x"1016ffff",
		x"1ad60010",
		x"1014eedb",
		x"16940010",
		x"1015a521",
		x"02b6a812",
		x"02957813",
		x"200f0028",
		x"10146d8f",
		x"16940010",
		x"10154b15",
		x"02b6a812",
		x"02958013",
		x"20100029",
		x"1014001f",
		x"1c080000",
		x"01e87810",
		x"1c080001",
		x"02088010",
		x"10020001",
		x"1003000d",
		x"14440001",
		x"04850001",
		x"01f07012",
		x"01c07014",
		x"11cd0000",
		x"01d07012",
		x"01c07014",
		x"01af6812",
		x"01a06814",
		x"01ae4012",
		x"01004014",
		x"02903812",
		x"08ea0020",
		x"00084813",
		x"100b0000",
		x"28eb0003",
		x"15290001",
		x"056b0001",
		x"3000007a",
		x"100b0000",
		x"294b0003",
		x"19080001",
		x"096b0001",
		x"3000007f",
		x"01284813",
		x"1c880000",
		x"01097810",
		x"01f07012",
		x"01c07014",
		x"11cd0000",
		x"01d07012",
		x"01c07014",
		x"01af6812",
		x"01a06814",
		x"01ae4012",
		x"01004014",
		x"028f3812",
		x"08ea0020",
		x"00084813",
		x"100b0000",
		x"28eb0003",
		x"15290001",
		x"056b0001",
		x"30000093",
		x"100b0000",
		x"294b0003",
		x"19080001",
		x"096b0001",
		x"30000098",
		x"01284813",
		x"1ca80000",
		x"01098010",
		x"04420001",
		x"2443ffca",
		x"200f002a",
		x"2010002b",
		x"1c0f002a",
		x"1c10002b",
		x"1014001f",
		x"1002000c",
		x"14440001",
		x"04850001",
		x"1ca80000",
		x"02084011",
		x"028f3812",
		x"08ea0020",
		x"00084813",
		x"100b0000",
		x"28eb0003",
		x"19290001",
		x"056b0001",
		x"300000af",
		x"100b0000",
		x"294b0003",
		x"15080001",
		x"096b0001",
		x"300000b4",
		x"01098013",
		x"01f07012",
		x"01c07014",
		x"11cd0000",
		x"01d07012",
		x"01c07014",
		x"01af6812",
		x"01a06814",
		x"01ae4012",
		x"01008014",
		x"1c880000",
		x"01e84011",
		x"02903812",
		x"08ea0020",
		x"00084813",
		x"100b0000",
		x"28eb0003",
		x"19290001",
		x"056b0001",
		x"300000c8",
		x"100b0000",
		x"294b0003",
		x"15080001",
		x"096b0001",
		x"300000cd",
		x"01097813",
		x"01f07012",
		x"01c07014",
		x"11cd0000",
		x"01d07012",
		x"01c07014",
		x"01af6812",
		x"01a06814",
		x"01ae4012",
		x"01007814",
		x"08420001",
		x"2c02ffca",
		x"1c080001",
		x"02088011",
		x"1c080000",
		x"01e87811",
		x"200f002c",
		x"2010002d",
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