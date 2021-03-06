library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
   Port ( clk : in std_logic;
          cpu_rst : in std_logic;
          sw : in std_logic_vector (15 downto 0);
          led : out std_logic_vector (15 downto 0);
          btn : in std_logic_vector (4 downto 0);
          -- 7-seg
          seg : out std_logic_vector (6 downto 0);
          an : out std_logic_vector (7 downto 0)
--          dp : out std_logic
--          tx : out std_logic;
--          rx : in std_logic
--          -- inst update
--          prog_addr : in std_logic_vector (31 downto 0);
--          prog_wd : in std_logic_vector (31 downto 0);
--          prog_clk : in std_logic;
--          -- debug signal
--          debug_0 : out std_logic_vector (31 downto 0);
--          debug_1 : out std_logic_vector (31 downto 0)
          );
end cpu;

architecture Behavioral of cpu is

--    -- if not fixed instructions
--    signal prog_addr : std_logic_vector (31 downto 0) := (others=>'0');
    signal prog_wd : std_logic_vector (31 downto 0) := (others=>'0');
    signal prog_clk : std_logic := '0';
    
    component reset_unit is
    Port ( clk : in STD_LOGIC;
           rst_in : in STD_LOGIC;
           rst_out : out STD_LOGIC);
    end component;

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
    
    component ins_mem is
     Port ( inst : out STD_LOGIC_VECTOR (31 downto 0);
            addr : in STD_LOGIC_VECTOR (31 downto 0);
--            w_addr : in STD_LOGIC_VECTOR (31 downto 0);
            wd: in STD_LOGIC_VECTOR (31 downto 0);
            clk: in STD_LOGIC);
    end component;
    
    component ctrl_unit is
        Port ( lw : out STD_LOGIC;
               sw : out STD_LOGIC;
               branch : out STD_LOGIC;
               bnc_type : out STD_LOGIC_VECTOR (1 downto 0);
               jump : out STD_LOGIC;
               funct : out STD_LOGIC_VECTOR (2 downto 0);
               op2src : out STD_LOGIC;
               regdst : out STD_LOGIC;
               regwrt : out STD_LOGIC;
               inst : in STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component reg_file is
        Port ( rd1 : out STD_LOGIC_VECTOR (31 downto 0);
               rd2 : out STD_LOGIC_VECTOR (31 downto 0);
               clk : in STD_LOGIC;
--               rst : in STD_LOGIC;
               we : in STD_LOGIC;
               rs : in STD_LOGIC_VECTOR (4 downto 0);
               rt : in STD_LOGIC_VECTOR (4 downto 0);
               rd : in STD_LOGIC_VECTOR (4 downto 0);
               wd : in STD_LOGIC_VECTOR (31 downto 0);
               r31 : in STD_LOGIC_VECTOR (31 downto 0); -- read-only
               r30 : out STD_LOGIC_VECTOR (31 downto 0);
               r29 : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component alu is
        Port ( result : out STD_LOGIC_VECTOR (31 downto 0);
               eq : out STD_LOGIC;
               lt : out STD_LOGIC;
               op1 : in STD_LOGIC_VECTOR (31 downto 0);
               op2 : in STD_LOGIC_VECTOR (31 downto 0);
               funct : in STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
    component sign_ext is
        Port ( imm32 : out STD_LOGIC_VECTOR (31 downto 0);
               imm16 : in STD_LOGIC_VECTOR (15 downto 0));
    end component; 
    
    component data_mem is
        Port ( rd : out STD_LOGIC_VECTOR (31 downto 0);
               clk : in STD_LOGIC;
--               rst : in STD_LOGIC;
               we : in STD_LOGIC;
               addr : in STD_LOGIC_VECTOR (31 downto 0);
               wd : in STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component debounce32 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               din : in STD_LOGIC_VECTOR (31 downto 0);
               dout : out STD_LOGIC_VECTOR (31 downto 0)
             );
    end component;
    
    component seg_led is
        Port ( seg_din : in STD_LOGIC_VECTOR (31 downto 0);
               led_din : in STD_LOGIC_VECTOR (31 downto 0);
               seg : out STD_LOGIC_VECTOR (6 downto 0);
--               dp : out STD_LOGIC;
               an : out STD_LOGIC_VECTOR (7 downto 0);
               led : out STD_LOGIC_VECTOR (15 downto 0);
               rst : in STD_LOGIC;
               clk : in STD_LOGIC);
    end component;
    
    --
    signal rst_sync : std_logic;
    
    -- pc
    signal pc : std_logic_vector (31 downto 0);
--    signal pc : unsigned (31 downto 0);
--    signal pc_pl4 : unsigned (31 downto 0);
--    signal pc_offset : unsigned (31 downto 0);
--    signal pc_src : std_logic_vector (1 downto 0);
    
    -- instruction
    signal inst : std_logic_vector (31 downto 0);
    signal inst_opcode : std_logic_vector (5 downto 0);
    signal inst_rs : std_logic_vector (4 downto 0);
    signal inst_rt : std_logic_vector (4 downto 0);
    signal inst_rd : std_logic_vector (4 downto 0);
    signal inst_funct : std_logic_vector (5 downto 0);
    signal inst_imm : std_logic_vector (15 downto 0);
    signal inst_addr : std_logic_vector (25 downto 0);
    
    -- control signals
    signal ctrl_lw : std_logic;
    signal ctrl_sw : std_logic;
    signal ctrl_branch : std_logic;
    signal ctrl_bnc_type : std_logic_vector (1 downto 0);  
    signal ctrl_jump : std_logic;
    signal ctrl_funct : std_logic_vector (2 downto 0);
    signal ctrl_op2src : std_logic;
    signal ctrl_regdst : std_logic;
    signal ctrl_regwrt : std_logic;
    
    -- register file
    signal reg_rd1 : std_logic_vector (31 downto 0);
    signal reg_rd2 : std_logic_vector (31 downto 0);
    signal reg_op1 : std_logic_vector (31 downto 0);
    signal reg_op2 : std_logic_vector (31 downto 0);
    signal reg_wd : std_logic_vector (31 downto 0);
    signal reg_dst : std_logic_vector (4 downto 0);
    
    -- alu
    signal imm_sign_ext : std_logic_vector (31 downto 0);
    signal alu_op2 : std_logic_vector (31 downto 0);
    signal alu_result : std_logic_vector (31 downto 0);
    signal alu_condi : std_logic;
    signal alu_eq : std_logic;
    signal alu_lt : std_logic;
    
    -- data memory
    signal mem_rd : std_logic_vector (31 downto 0);  
    signal mem_addr : std_logic_vector (31 downto 0);
    
    -- btn & sw debouncing
    signal r31_raw_btn_sw : std_logic_vector (31 downto 0);
    signal r31_debounced : std_logic_vector (31 downto 0);
    
    -- 7-seg and led display
    signal seg_reg : std_logic_vector (31 downto 0);
    signal led_reg : std_logic_vector (31 downto 0);
    
--    signal clk_div : std_logic := '0';
    signal clk_src : std_logic;
    signal rst : std_logic;
    
    component clk_wiz_0 is
        port (
            clk_out1: out std_logic;
            resetn: in std_logic;
            clk_in1: in std_logic);
    end component;

begin
    -----------------------------------------------------------------------------------------
    -- clock setup
    -----------------------------------------------------------------------------------------
    U_clk : clk_wiz_0               -- MMCM module 
        port map (
            clk_out1 => clk_src,    -- out: 135 MHz
            resetn => cpu_rst,      -- active-low
            clk_in1 => clk);        -- in:  100 MHz
            
--    clk_src <= clk;               -- or use on-board 100 MHz as clk_src directly
    

    -----------------------------------------------------------------------------------------
    -- reset setup
    -----------------------------------------------------------------------------------------
    rst <= not cpu_rst;             -- on-board rst button is active-low, make it active-high
    U_rst : reset_unit              -- async reset, sync release
        Port map ( 
            clk => clk_src,         
            rst_in => rst,
            rst_out => rst_sync);  


    -----------------------------------------------------------------------------------------
    -- reset PC
    -----------------------------------------------------------------------------------------
    U_pc : pc_unit
        Port map ( 
            clk => clk_src,
            rst => rst_sync,
            branch => ctrl_branch,
            condi => alu_condi,
            jump => ctrl_jump,
            offset => imm_sign_ext,
            addr => inst_addr,
            pc_next => pc);
    
    
--    process(clk_src)
--    begin
--        if rising_edge(clk_src) then
--            if ctrl_regwrt = '1' then
--                case reg_dst is
--                    when "11110" => 
--                        seg_reg <= reg_wd;
--                    when "11101" =>
--                        led_reg <= reg_wd;
--                    when others =>
--                        null;
--                end case;
--            end if;
--        end if;
--    end process;
            
    -- inst decompose
    inst_opcode <= inst(31 downto 26);
    inst_rs <= inst(25 downto 21);
    inst_rt <= inst(20 downto 16);
    inst_rd <= inst(15 downto 11);
    inst_funct <= inst(5 downto 0);
    inst_imm <= inst(15 downto 0);
    inst_addr <= inst(25 downto 0);
    
    -- inst mem
--    pc(9 downto 0) <= prog_addr or pc_run(9 downto 0);
--    pc(31 downto 10) <= pc_run(31 downto 10);
--    pc <= prog_addr or pc_run;
    U_ins_mem : ins_mem 
       port map ( inst => inst,
                  addr => pc,
--                  w_addr => prog_addr,
                  wd => prog_wd,
                  clk => prog_clk);
    
    with ctrl_bnc_type select alu_condi <= alu_eq when "11", not alu_eq when "01", alu_lt when "10", '0' when others;
    U_ctrl_unit : ctrl_unit
        port map ( lw => ctrl_lw,
                   sw => ctrl_sw,
                   branch => ctrl_branch,
                   bnc_type => ctrl_bnc_type,
                   jump => ctrl_jump,
                   funct => ctrl_funct,
                   op2src => ctrl_op2src,
                   regdst => ctrl_regdst,
                   regwrt => ctrl_regwrt,
                   inst => inst);
    
--    with inst_rs select reg_op1 <= r31_debounced when "11111", reg_rd1 when others;
--    with inst_rt select reg_op2 <= r31_debounced when "11111", reg_rd2 when others;
    with ctrl_regdst select reg_dst <= inst_rd when '1', inst_rt when others;
    U_reg_file : reg_file
        port map ( rd1 => reg_rd1,
                   rd2 => reg_rd2,
                   clk => clk_src,
--                   rst => rst_sync,
                   we => ctrl_regwrt,
                   rs => inst_rs,
                   rt => inst_rt,
                   rd => reg_dst,
                   wd => reg_wd,
                   r31 => r31_debounced,
                   r30 => seg_reg,
                   r29 => led_reg);
                   
    r31_raw_btn_sw (31 downto 21) <= (others=> '0');
    r31_raw_btn_sw (20 downto 16) <= btn;
    r31_raw_btn_sw (15 downto 0) <= sw;
    U_debounce32 : debounce32 
        port map (
            clk=>clk_src, 
            rst=>rst_sync, 
            din=>r31_raw_btn_sw, 
            dout=>r31_debounced);
                  
    U_seg_led : seg_led
        Port map ( seg_din => seg_reg,
                   led_din => led_reg,
                   seg => seg,
--                   dp => dp,
                   an => an,
                   led => led,
                   rst => rst_sync,
                   clk => clk_src);
                   
    with ctrl_op2src select alu_op2 <= imm_sign_ext when '1', reg_rd2 when others;
    U_alu : alu 
        port map ( result => alu_result,
                   eq => alu_eq,
                   lt => alu_lt,
                   op1 => reg_rd1,
                   op2 => alu_op2,
                   funct => ctrl_funct);
                   
    U_sign_ext : sign_ext
        port map ( imm32 => imm_sign_ext,
                   imm16 => inst_imm);
    
    mem_addr <= std_logic_vector(signed(reg_rd1)+signed(imm_sign_ext));
    U_data_mem : data_mem
        port map ( rd => mem_rd,
                   clk => clk_src,
--                   rst => rst_sync,
                   we => ctrl_sw,
                   addr => mem_addr,
                   wd => reg_rd2);
    
    with ctrl_lw select reg_wd <= mem_rd when '1', alu_result when others;
    
end Behavioral;
