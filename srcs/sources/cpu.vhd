library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
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
          prog_clk : in std_logic
          );
end cpu;

architecture Behavioral of cpu is

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
            wd: in STD_LOGIC_VECTOR (31 downto 0);
            w_clk: in STD_LOGIC);
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
               rst : in STD_LOGIC;
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
               rst : in STD_LOGIC;
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
               dp : out STD_LOGIC;
               an : out std_logic_vector (3 downto 0);
               led : out STD_LOGIC_VECTOR (15 downto 0);
               clk : in STD_LOGIC);
    end component;
    
    -- pc
    signal pc : std_logic_vector (31 downto 0);
    signal pc_run : std_logic_vector (31 downto 0); 
    
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
    
    -- btn & sw debouncing
    signal r31_raw_btn_sw : std_logic_vector (31 downto 0);
    signal r31_debounced : std_logic_vector (31 downto 0);
    
    -- 7-seg and led display
    signal seg_din : std_logic_vector (31 downto 0);
    signal led_din : std_logic_vector (31 downto 0);

begin

    -- pc_run
   U_PC : pc_unit
        Port map ( 
            clk => clk,
            rst => rst,
            branch => ctrl_branch,
            condi => alu_condi,
            jump => ctrl_jump,
            offset => imm_sign_ext,
            addr => inst_addr,
            pc_next => pc_run);
    
    -- inst decompose
    inst_opcode <= inst(31 downto 26);
    inst_rs <= inst(25 downto 21);
    inst_rt <= inst(20 downto 16);
    inst_rd <= inst(15 downto 11);
    inst_funct <= inst(5 downto 0);
    inst_imm <= inst(15 downto 0);
    inst_addr <= inst(25 downto 0);
    
    -- inst mem
    pc <= prog_addr or pc_run;
    U_ins_mem : ins_mem 
       port map ( inst => inst,
                  addr => pc,
                  wd => prog_wd,
                  w_clk => prog_clk);
    
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
    
    with ctrl_regdst select reg_dst <= inst_rd when '1', inst_rt when others;
    U_reg_file : reg_file
        port map ( rd1 => reg_rd1,
                   rd2 => reg_rd2,
                   clk => clk,
                   rst => rst,
                   we => ctrl_regwrt,
                   rs => inst_rs,
                   rt => inst_rt,
                   rd => reg_dst,
                   wd => reg_wd,
                   r31 => r31_debounced,
                   r30 => seg_din,
                   r29 => led_din);
                   
    r31_raw_btn_sw (31 downto 21) <= (others=> '0');
    r31_raw_btn_sw (20 downto 16) <= btn;
    r31_raw_btn_sw (15 downto 0) <= sw;
    U_debounce32 : debounce32 port map (clk=>clk, rst=>rst, din=>r31_raw_btn_sw, dout=>r31_debounced);
                  
    U_seg_led : seg_led
        Port map ( seg_din => seg_din,
                   led_din => led_din,
                   seg => seg,
                   dp => dp,
                   an => an,
                   led => led,
                   clk => clk);
                   
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
                   
    U_data_mem : data_mem
        port map ( rd => mem_rd,
                   clk => clk,
                   rst => rst,
                   we => ctrl_sw,
                   addr => alu_result,
                   wd => reg_rd2);
    
    with ctrl_lw select reg_wd <= mem_rd when '1', alu_result when others;

end Behavioral;
