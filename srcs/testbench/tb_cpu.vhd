library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.math_real.all;
use STD.textio.all;
use ieee.std_logic_textio.all;


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
--    signal debug_0 : std_logic_vector (31 downto 0);
--    signal debug_1 : std_logic_vector (31 downto 0);
    
    constant clk_period : time := 10 ns;
    constant btn_delay : time := 200 ns;
    file file_VECTORS : text;
    
    type type_check_state is (CHECKING, FAILED, PASSED);
    signal check_state : type_check_state := CHECKING;
    
    type PROG is array(0 to 2047) of STD_LOGIC_VECTOR (31 downto 0);
    constant program : PROG := (
-- >>> start >>>
	x"00000011",x"10010001",x"1002ffff",x"10340000",x"16950001",x"16b60001",x"16d70001",x"16f80001",x"1019ffff",x"1b390010",x"101a001f",x"173b0010",x"10030008",x"10040100",x"18840001",x"08630001",x"2064005a",x"2c03fffc",x"10130001",x"10120000",x"1bfc0010",x"2c1cfffe",x"101d0000",x"10110005",x"0253f013",x"1bfc0010",x"0396e012",x"2edc0007",x"0a730001",x"2c130001",x"0a330001",x"0253f013",x"1bfc0010",x"0396e012",x"2adcfffd",x"1bfc0010",x"0397e012",x"2efc0007",x"06730001",x"2e330001",x"04130001",x"0253f013",x"1bfc0010",x"0397e012",x"2afcfffd",x"1bfc0010",x"0394e012",x"2e9c000c",x"100a0001",x"2d530001",x"3000003d",x"100a0002",x"2d530001",x"30000071",x"100a0003",x"2d530001",x"30000176",x"100a0004",x"2d530001",x"300002dc",x"30000018",x"1bfc0010",x"2c1cfffe",x"10030007",x"100d0007",x"10110000",x"033f5812",x"156b0010",x"1c6a003c",x"016af013",x"1c7d005a",x"1bfc0010",x"0391e012",x"2c1cfffd",x"10110000",x"1bfc0010",x"0396e012",x"2edc0004",x"29a30001",x"04630001",x"12d10000",x"30000042",x"1bfc0010",x"0397e012",x"2efc0004",x"28030001",x"08630001",x"12f10000",x"30000042",x"1bfc0010",x"0394e012",x"2e9c0004",x"033f5012",x"206a003c",x"12910000",x"30000042",x"1bfc0010",x"0398e012",x"2f1c0001",x"30000065",x"30000042",x"10030003",x"14640001",x"04850001",x"1cab003c",x"156b0010",x"1c8a003c",x"032a5012",x"016a5013",x"206a0032",x"08630001",x"2c43fff6",x"300000a5",x"1bfc0010",x"2c1cfffe",x"10030003",x"100d0003",x"10110000",x"033f5812",x"156b0010",x"1c6a0046",x"016af013",x"1c7d005a",x"1bfc0010",x"0391e012",x"2c1cfffd",x"10110000",x"1bfc0010",x"0396e012",x"2edc0004",x"29a30001",x"04630001",x"12d10000",x"30000076",x"1bfc0010",x"0397e012",x"2efc0004",x"28030001",x"08630001",x"12f10000",x"30000076",x"1bfc0010",x"0394e012",x"2e9c0004",x"033f5012",x"206a0046",x"12910000",x"30000076",x"1bfc0010",x"0398e012",x"2f1c0001",x"30000099",x"30000076",x"10030001",x"14640001",x"04850001",x"1cab0046",x"156b0010",x"1c8a0046",x"032a5012",x"016a5013",x"206a0036",x"08630001",x"2c43fff6",x"30000014",x"10030003",x"1c6a0032",x"206a001a",x"08630001",x"2443fffc",x"100bb7e1",x"156b0010",x"0f2a5163",x"016a4013",x"100b9e37",x"156b0010",x"0f2a79b9",x"016a4813",x"11070000",x"20070000",x"10030001",x"1004001a",x"00e93810",x"20670000",x"04630001",x"2464fffc",x"10030000",x"10040000",x"10050000",x"100d001a",x"100e0004",x"100f004e",x"10080000",x"10090000",x"01093010",x"1c670000",x"00e63810",x"14eb0003",x"18ea001d",x"016a4013",x"20680000",x"01093010",x"1c87001a",x"00e63810",x"03066012",x"2b0c004e",x"02e66012",x"2aec0026",x"02c66012",x"2acc0012",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb0000",x"18ea0020",x"30000169",x"14eb0001",x"18ea001f",x"30000169",x"02866012",x"2a8c0003",x"14eb0002",x"18ea001e",x"30000169",x"14eb0003",x"18ea001d",x"30000169",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb0004",x"18ea001c",x"30000169",x"14eb0005",x"18ea001b",x"30000169",x"02866012",x"2a8c0003",x"14eb0006",x"18ea001a",x"30000169",x"14eb0007",x"18ea0019",x"30000169",x"02c66012",x"2acc0012",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb0008",x"18ea0018",x"30000169",x"14eb0009",
	x"18ea0017",x"30000169",x"02866012",x"2a8c0003",x"14eb000a",x"18ea0016",x"30000169",x"14eb000b",x"18ea0015",x"30000169",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb000c",x"18ea0014",x"30000169",x"14eb000d",x"18ea0013",x"30000169",x"02866012",x"2a8c0003",x"14eb000e",x"18ea0012",x"30000169",x"14eb000f",x"18ea0011",x"30000169",x"02e66012",x"2aec0026",x"02c66012",x"2acc0012",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb0010",x"18ea0010",x"30000169",x"14eb0011",x"18ea000f",x"30000169",x"02866012",x"2a8c0003",x"14eb0012",x"18ea000e",x"30000169",x"14eb0013",x"18ea000d",x"30000169",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb0014",x"18ea000c",x"30000169",x"14eb0015",x"18ea000b",x"30000169",x"02866012",x"2a8c0003",x"14eb0016",x"18ea000a",x"30000169",x"14eb0017",x"18ea0009",x"30000169",x"02c66012",x"2acc0012",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb0018",x"18ea0008",x"30000169",x"14eb0019",x"18ea0007",x"30000169",x"02866012",x"2a8c0003",x"14eb001a",x"18ea0006",x"30000169",x"14eb001b",x"18ea0005",x"30000169",x"02a66012",x"2aac0008",x"02866012",x"2a8c0003",x"14eb001c",x"18ea0004",x"30000169",x"14eb001d",x"18ea0003",x"30000169",x"02866012",x"2a8c0003",x"14eb001e",x"18ea0002",x"30000169",x"14eb001f",x"18ea0001",x"016a4813",x"2089001a",x"04630001",x"04840001",x"246d0001",x"10030000",x"248e0001",x"10040000",x"04a50001",x"24afff4f",x"10128888",x"16520010",x"30000014",x"1c080037",x"1c090036",x"1c070000",x"01074010",x"1c070001",x"01274810",x"10030001",x"100d000d",x"14640001",x"04850001",x"01095814",x"01095012",x"014b3814",x"03096012",x"2b0c004e",x"02e96012",x"2aec0026",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb0000",x"18ea0020",x"30000220",x"14eb0001",x"18ea001f",x"30000220",x"02896012",x"2a8c0003",x"14eb0002",x"18ea001e",x"30000220",x"14eb0003",x"18ea001d",x"30000220",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb0004",x"18ea001c",x"30000220",x"14eb0005",x"18ea001b",x"30000220",x"02896012",x"2a8c0003",x"14eb0006",x"18ea001a",x"30000220",x"14eb0007",x"18ea0019",x"30000220",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb0008",x"18ea0018",x"30000220",x"14eb0009",x"18ea0017",x"30000220",x"02896012",x"2a8c0003",x"14eb000a",x"18ea0016",x"30000220",x"14eb000b",x"18ea0015",x"30000220",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb000c",x"18ea0014",x"30000220",x"14eb000d",x"18ea0013",x"30000220",x"02896012",x"2a8c0003",x"14eb000e",x"18ea0012",x"30000220",x"14eb000f",x"18ea0011",x"30000220",x"02e96012",x"2aec0026",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb0010",x"18ea0010",x"30000220",x"14eb0011",x"18ea000f",x"30000220",x"02896012",x"2a8c0003",x"14eb0012",x"18ea000e",x"30000220",x"14eb0013",x"18ea000d",x"30000220",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb0014",x"18ea000c",x"30000220",x"14eb0015",x"18ea000b",x"30000220",x"02896012",x"2a8c0003",x"14eb0016",x"18ea000a",x"30000220",x"14eb0017",x"18ea0009",x"30000220",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",
	x"2a8c0003",x"14eb0018",x"18ea0008",x"30000220",x"14eb0019",x"18ea0007",x"30000220",x"02896012",x"2a8c0003",x"14eb001a",x"18ea0006",x"30000220",x"14eb001b",x"18ea0005",x"30000220",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"14eb001c",x"18ea0004",x"30000220",x"14eb001d",x"18ea0003",x"30000220",x"02896012",x"2a8c0003",x"14eb001e",x"18ea0002",x"30000220",x"14eb001f",x"18ea0001",x"016a5013",x"1c870000",x"01474010",x"01095814",x"01095012",x"014b3814",x"03086012",x"2b0c004e",x"02e86012",x"2aec0026",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb0000",x"18ea0020",x"300002c3",x"14eb0001",x"18ea001f",x"300002c3",x"02886012",x"2a8c0003",x"14eb0002",x"18ea001e",x"300002c3",x"14eb0003",x"18ea001d",x"300002c3",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb0004",x"18ea001c",x"300002c3",x"14eb0005",x"18ea001b",x"300002c3",x"02886012",x"2a8c0003",x"14eb0006",x"18ea001a",x"300002c3",x"14eb0007",x"18ea0019",x"300002c3",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb0008",x"18ea0018",x"300002c3",x"14eb0009",x"18ea0017",x"300002c3",x"02886012",x"2a8c0003",x"14eb000a",x"18ea0016",x"300002c3",x"14eb000b",x"18ea0015",x"300002c3",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb000c",x"18ea0014",x"300002c3",x"14eb000d",x"18ea0013",x"300002c3",x"02886012",x"2a8c0003",x"14eb000e",x"18ea0012",x"300002c3",x"14eb000f",x"18ea0011",x"300002c3",x"02e86012",x"2aec0026",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb0010",x"18ea0010",x"300002c3",x"14eb0011",x"18ea000f",x"300002c3",x"02886012",x"2a8c0003",x"14eb0012",x"18ea000e",x"300002c3",x"14eb0013",x"18ea000d",x"300002c3",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb0014",x"18ea000c",x"300002c3",x"14eb0015",x"18ea000b",x"300002c3",x"02886012",x"2a8c0003",x"14eb0016",x"18ea000a",x"300002c3",x"14eb0017",x"18ea0009",x"300002c3",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb0018",x"18ea0008",x"300002c3",x"14eb0019",x"18ea0007",x"300002c3",x"02886012",x"2a8c0003",x"14eb001a",x"18ea0006",x"300002c3",x"14eb001b",x"18ea0005",x"300002c3",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"14eb001c",x"18ea0004",x"300002c3",x"14eb001d",x"18ea0003",x"300002c3",x"02886012",x"2a8c0003",x"14eb001e",x"18ea0002",x"300002c3",x"14eb001f",x"18ea0001",x"016a5013",x"1ca70000",x"01474810",x"04630001",x"2da3feb6",x"2008001f",x"2009001e",x"1c1e001f",x"1c3d005a",x"1bfc0010",x"2c1cfffe",x"1bfc0010",x"0396e012",x"2edc0002",x"1c1e001f",x"1c3d005a",x"1bfc0010",x"0397e012",x"2efc0002",x"1c1e001e",x"1c1d005a",x"1bfc0010",x"0398e012",x"2f1cfff3",x"30000014",x"1c080037",x"1c090036",x"1003000c",x"14640001",x"04850001",x"1ca70000",x"01273811",x"03086012",x"2b0c004e",x"02e86012",x"2aec0026",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb0000",x"14ea0020",x"30000380",x"18eb0001",x"14ea001f",x"30000380",x"02886012",x"2a8c0003",x"18eb0002",x"14ea001e",x"30000380",x"18eb0003",x"14ea001d",x"30000380",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb0004",
	x"14ea001c",x"30000380",x"18eb0005",x"14ea001b",x"30000380",x"02886012",x"2a8c0003",x"18eb0006",x"14ea001a",x"30000380",x"18eb0007",x"14ea0019",x"30000380",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb0008",x"14ea0018",x"30000380",x"18eb0009",x"14ea0017",x"30000380",x"02886012",x"2a8c0003",x"18eb000a",x"14ea0016",x"30000380",x"18eb000b",x"14ea0015",x"30000380",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb000c",x"14ea0014",x"30000380",x"18eb000d",x"14ea0013",x"30000380",x"02886012",x"2a8c0003",x"18eb000e",x"14ea0012",x"30000380",x"18eb000f",x"14ea0011",x"30000380",x"02e86012",x"2aec0026",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb0010",x"14ea0010",x"30000380",x"18eb0011",x"14ea000f",x"30000380",x"02886012",x"2a8c0003",x"18eb0012",x"14ea000e",x"30000380",x"18eb0013",x"14ea000d",x"30000380",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb0014",x"14ea000c",x"30000380",x"18eb0015",x"14ea000b",x"30000380",x"02886012",x"2a8c0003",x"18eb0016",x"14ea000a",x"30000380",x"18eb0017",x"14ea0009",x"30000380",x"02c86012",x"2acc0012",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb0018",x"14ea0008",x"30000380",x"18eb0019",x"14ea0007",x"30000380",x"02886012",x"2a8c0003",x"18eb001a",x"14ea0006",x"30000380",x"18eb001b",x"14ea0005",x"30000380",x"02a86012",x"2aac0008",x"02886012",x"2a8c0003",x"18eb001c",x"14ea0004",x"30000380",x"18eb001d",x"14ea0003",x"30000380",x"02886012",x"2a8c0003",x"18eb001e",x"14ea0002",x"30000380",x"18eb001f",x"14ea0001",x"016a4813",x"01095814",x"01095012",x"014b4814",x"1c870000",x"01073811",x"03096012",x"2b0c004e",x"02e96012",x"2aec0026",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb0000",x"14ea0020",x"30000423",x"18eb0001",x"14ea001f",x"30000423",x"02896012",x"2a8c0003",x"18eb0002",x"14ea001e",x"30000423",x"18eb0003",x"14ea001d",x"30000423",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb0004",x"14ea001c",x"30000423",x"18eb0005",x"14ea001b",x"30000423",x"02896012",x"2a8c0003",x"18eb0006",x"14ea001a",x"30000423",x"18eb0007",x"14ea0019",x"30000423",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb0008",x"14ea0018",x"30000423",x"18eb0009",x"14ea0017",x"30000423",x"02896012",x"2a8c0003",x"18eb000a",x"14ea0016",x"30000423",x"18eb000b",x"14ea0015",x"30000423",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb000c",x"14ea0014",x"30000423",x"18eb000d",x"14ea0013",x"30000423",x"02896012",x"2a8c0003",x"18eb000e",x"14ea0012",x"30000423",x"18eb000f",x"14ea0011",x"30000423",x"02e96012",x"2aec0026",x"02c96012",x"2acc0012",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb0010",x"14ea0010",x"30000423",x"18eb0011",x"14ea000f",x"30000423",x"02896012",x"2a8c0003",x"18eb0012",x"14ea000e",x"30000423",x"18eb0013",x"14ea000d",x"30000423",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb0014",x"14ea000c",x"30000423",x"18eb0015",x"14ea000b",x"30000423",x"02896012",x"2a8c0003",x"18eb0016",x"14ea000a",x"30000423",x"18eb0017",x"14ea0009",x"30000423",x"02c96012",x"2acc0012",
	x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb0018",x"14ea0008",x"30000423",x"18eb0019",x"14ea0007",x"30000423",x"02896012",x"2a8c0003",x"18eb001a",x"14ea0006",x"30000423",x"18eb001b",x"14ea0005",x"30000423",x"02a96012",x"2aac0008",x"02896012",x"2a8c0003",x"18eb001c",x"14ea0004",x"30000423",x"18eb001d",x"14ea0003",x"30000423",x"02896012",x"2a8c0003",x"18eb001e",x"14ea0002",x"30000423",x"18eb001f",x"14ea0001",x"016a4013",x"01095814",x"01095012",x"014b4014",x"08630001",x"2c03feb6",x"1c070001",x"01274811",x"1c070000",x"01074011",x"20080021",x"20090020",x"1c1e0021",x"1c3d005a",x"1bfc0010",x"2c1cfffe",x"1bfc0010",x"0396e012",x"2edc0002",x"1c1e0021",x"1c3d005a",x"1bfc0010",x"0397e012",x"2efc0002",x"1c1e0020",x"1c1d005a",x"1bfc0010",x"0398e012",x"2f1cfff3",x"30000014",x"100b1946",x"156b0010",x"0f2a5f91",x"016a5013",x"200a0032",x"100b51b2",x"156b0010",x"0f2a41be",x"016a5013",x"200a0033",x"100b01a5",x"156b0010",x"0f2a5563",x"016a5013",x"200a0034",x"100b91ce",x"156b0010",x"0f2aa910",x"016a5013",x"200a0035",x"300000a5",x"100beedb",x"156b0010",x"0f2aa521",x"016a5013",x"200a0036",x"100b6d8f",x"156b0010",x"0f2a4b15",x"016a5013",x"200a0037",x"30000014",x"fc000461",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",
	x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",
	x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",
	x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",		x"ffffffff"
-- <<< end <<<
    );
    
    type type_segcode is array (0 to 15) of std_logic_vector (6 downto 0);
    constant seg_code : type_segcode := (
        "1000000", "1111001", "0100100", "0110000",
        "0011001", "0010010", "0000010", "1111000",
        "0000000", "0010000", "0001000", "0000011",
        "1000110", "0100001", "0000110", "0001110");
        
    type type_ancode is array (0 to 7) of std_logic_vector (7 downto 0);
    constant an_code : type_ancode := (
        "11111110", "11111101", "11111011", "11110111",
        "11101111", "11011111", "10111111", "01111111");
    
begin

    clk <= not clk after clk_period/2;
    
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
        variable v_ILINE : line;
        variable ukey : std_logic_vector(127 downto 0);
        variable txt : std_logic_vector(63 downto 0);
        variable expected : std_logic_vector(63 downto 0);    
    begin
        
        -- reseting
        rst <= '0';
        sw <= (others => '0');
        btn <= (others => '0');
        prog_addr <= (others => '0');
        prog_wd <= (others => '0');
        prog_clk <= '0';
        wait for 200ns;
        
        -- 10000 cases
        file_open(file_VECTORS, "../randcase.txt",  read_mode);
        check_state <= CHECKING;
        rst <= '1';
        wait for clk_period*50;
        
        for i in 1 to 10 loop
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
--            rst <= '1';
--            prog_addr <= std_logic_vector( TO_UNSIGNED(0, 32));
--            wait for clk_period*10;
            
            -- input ukey
            readline(file_VECTORS, v_ILINE);
            read(v_ILINE, ukey);
            btn(0) <= '1'; wait for btn_delay; btn(0) <= '0'; wait for btn_delay;           
            for k in 7 downto 0 loop
                sw <= ukey(k*16+15 downto k*16);
                btn(0) <= '1'; wait for btn_delay; btn(0) <= '0'; wait for btn_delay; 
                btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay;
            end loop;
            
            -- wait for key expansion
            btn(4) <= '1'; wait for btn_delay; btn(4) <= '0'; wait for btn_delay;
            wait for clk_period*2600;
            
            btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay;         
            for j in 1 to 1000 loop
                -- input din
                readline(file_VECTORS, v_ILINE);
                read(v_ILINE, txt);
                btn(0) <= '1'; wait for btn_delay; btn(0) <= '0'; wait for btn_delay;
                for k in 3 downto 0 loop
                    sw <= txt(k*16+15 downto k*16);
                    btn(0) <= '1'; wait for btn_delay; btn(0) <= '0'; wait for btn_delay; 
                    btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay;
                end loop;
                btn(4) <= '1'; wait for btn_delay; btn(4) <= '0'; wait for btn_delay;
                
                -- encryption
                btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay; 
                btn(0) <= '1'; wait for btn_delay; btn(0) <= '0'; wait for btn_delay;
                wait for clk_period*600;
                
                readline(file_VECTORS, v_ILINE);
                read(v_ILINE, expected);
                -- check 32MSB digit by digit
                for k in 7 downto 0 loop
                    wait until an <= an_code(k);
                    wait until falling_edge(clk);
                    assert seg = seg_code(TO_INTEGER(UNSIGNED(expected(k*4+3+32 downto k*4+32))))
                        report "wrong"
                            severity failure;
                end loop;
                btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay; 
                -- check 32MSB digit by digit
                for k in 7 downto 0 loop
                    wait until an <= an_code(k);
                    wait until falling_edge(clk);
                    assert seg = seg_code(TO_INTEGER(UNSIGNED(expected(k*4+3 downto k*4))))
                        report "wrong"
                            severity failure;
                end loop;
                -- back to main menu
                btn(4) <= '1'; wait for btn_delay; btn(4) <= '0'; wait for btn_delay;

                -- decryption
                btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay; 
                btn(0) <= '1'; wait for btn_delay; btn(0) <= '0'; wait for btn_delay;
                wait for clk_period*600;
                
                readline(file_VECTORS, v_ILINE);
                read(v_ILINE, expected);
                -- check 32MSB digit by digit
                for k in 7 downto 0 loop
                    wait until an <= an_code(k);
                    wait until falling_edge(clk);
                    assert seg = seg_code(TO_INTEGER(UNSIGNED(expected(k*4+3+32 downto k*4+32))))
                        report "wrong"
                            severity failure;
                end loop;
                btn(3) <= '1'; wait for btn_delay; btn(3) <= '0'; wait for btn_delay; 
                -- check 32MSB digit by digit
                for k in 7 downto 0 loop
                    wait until an <= an_code(k);
                    wait until falling_edge(clk);
                    assert seg = seg_code(TO_INTEGER(UNSIGNED(expected(k*4+3 downto k*4))))
                        report "wrong"
                            severity failure;
                end loop;
                -- back to main menu
                btn(4) <= '1'; wait for btn_delay; btn(4) <= '0'; wait for btn_delay;
                
                -- back to menu 2: din
                btn(2) <= '1'; wait for btn_delay; btn(2) <= '0'; wait for btn_delay; 
                btn(2) <= '1'; wait for btn_delay; btn(2) <= '0'; wait for btn_delay;          
             end loop;
             -- back to menu 1: ukey
             btn(2) <= '1'; wait for btn_delay; btn(2) <= '0'; wait for btn_delay; 
        end loop;
        
        check_state <= PASSED;
        wait for 20 ms;
        wait;
                   
    end process;


end Behavioral;