library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- recommended for arithmetic

entity Datapath is
    Port (
        CLK   : in  STD_LOGIC;
        INPR  : in  STD_LOGIC_VECTOR(15 downto 0);
        OUTR  : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Datapath;

architecture Behavioral of Datapath is

    ------------------------------------------------------------------------
    -- Component Declarations
    ------------------------------------------------------------------------
    component PC is
        Port (
            BUN_Address : in  STD_LOGIC_VECTOR(7 downto 0);
            BUN_En      : in  STD_LOGIC;
            PC_Inc      : in  STD_LOGIC;
            Address     : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component Instruction_Memory is
        Port (
            Address  : in  STD_LOGIC_VECTOR(7 downto 0);
            I_Read   : in  STD_LOGIC;
            Data_Out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component Data_Memory is
        Port (
            Address   : in  STD_LOGIC_VECTOR(7 downto 0);
            Reg_Value : in  STD_LOGIC_VECTOR(15 downto 0);
            Mem_Write : in  STD_LOGIC;
            Data_Out  : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component RegisterFile is
        Port (
            CLK        : in  STD_LOGIC;
            Rs_Address : in  STD_LOGIC_VECTOR(1 downto 0);
            Rd_Address : in  STD_LOGIC_VECTOR(1 downto 0);
            Reg_Write  : in  STD_LOGIC;
            Data_In    : in  STD_LOGIC_VECTOR(15 downto 0);
            Rs         : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component ALU is
        Port (
            Opcode : in  STD_LOGIC_VECTOR(2 downto 0);
            A      : in  STD_LOGIC_VECTOR(15 downto 0);
            B      : in  STD_LOGIC_VECTOR(15 downto 0);
            Result : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component Output_Mux is
        Port (
            Rs   : in  STD_LOGIC_VECTOR(15 downto 0);
            OUTR : out STD_LOGIC_VECTOR(15 downto 0);
            Sel  : in  STD_LOGIC
        );
    end component;

    component RegIn_Mux is
        Port (
            ALU_Out  : in  STD_LOGIC_VECTOR(15 downto 0);
            INPR     : in  STD_LOGIC_VECTOR(15 downto 0);
            DM_Out   : in  STD_LOGIC_VECTOR(15 downto 0);
            RegInSel : in  STD_LOGIC_VECTOR(1 downto 0);
            Reg_IN   : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component Control_Unit is
        Port (
            Opcode       : in  STD_LOGIC_VECTOR(3 downto 0);
            CLK          : in  STD_LOGIC;
            BUN_EN       : out STD_LOGIC;
            PC_INCREMENT : out STD_LOGIC;
            I_Read       : out STD_LOGIC;
            Reg_Write    : out STD_LOGIC;
            RegInSel     : out STD_LOGIC_VECTOR(1 downto 0);
            Out_EN       : out STD_LOGIC;
            ALU_OPCODE   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    ------------------------------------------------------------------------
    -- Internal Signals
    ------------------------------------------------------------------------
    signal pc_address       : STD_LOGIC_VECTOR(7 downto 0);
    signal instruction      : STD_LOGIC_VECTOR(15 downto 0);
    signal opcode           : STD_LOGIC_VECTOR(3 downto 0);
    signal rs_address       : STD_LOGIC_VECTOR(1 downto 0);
    signal rd_address       : STD_LOGIC_VECTOR(1 downto 0);

    signal reg_write_data   : STD_LOGIC_VECTOR(15 downto 0);
    signal rs_output        : STD_LOGIC_VECTOR(15 downto 0);

    signal alu_op           : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_result       : STD_LOGIC_VECTOR(15 downto 0);

    signal bun_en_s         : STD_LOGIC;
    signal pc_inc_s         : STD_LOGIC;
    signal i_read_s         : STD_LOGIC;
    signal reg_write_s      : STD_LOGIC;
    signal out_en_s         : STD_LOGIC;
    signal reg_in_sel_s     : STD_LOGIC_VECTOR(1 downto 0);

    signal data_mem_out     : STD_LOGIC_VECTOR(15 downto 0);
    signal outr_internal    : STD_LOGIC_VECTOR(15 downto 0);

begin

    ------------------------------------------------------------------------
    -- Program Counter
    ------------------------------------------------------------------------
    PC_Inst: PC
        port map (
            BUN_Address => instruction(7 downto 0),
            BUN_En      => bun_en_s,
            PC_Inc      => pc_inc_s,
            Address     => pc_address
        );

    ------------------------------------------------------------------------
    -- Instruction Memory
    ------------------------------------------------------------------------
    IM_Inst: Instruction_Memory
        port map (
            Address  => pc_address,
            I_Read   => i_read_s,
            Data_Out => instruction
        );

    ------------------------------------------------------------------------
    -- Control Unit
    ------------------------------------------------------------------------
    opcode <= instruction(15 downto 12);

    CU_Inst: Control_Unit
        port map (
            Opcode       => opcode,
            CLK          => CLK,
            BUN_EN       => bun_en_s,
            PC_INCREMENT => pc_inc_s,
            I_Read       => i_read_s,
            Reg_Write    => reg_write_s,
            RegInSel     => reg_in_sel_s,
            Out_EN       => out_en_s,
            ALU_OPCODE   => alu_op
        );

    ------------------------------------------------------------------------
    -- Register File
    ------------------------------------------------------------------------
    rs_address <= instruction(9 downto 8);
    rd_address <= instruction(11 downto 10);

    RF_Inst: RegisterFile
        port map (
            CLK        => CLK,
            Rs_Address => rs_address,
            Rd_Address => rd_address,
            Reg_Write  => reg_write_s,
            Data_In    => reg_write_data,
            Rs         => rs_output
        );

    ------------------------------------------------------------------------
    -- Data Memory (Second Operand for ALU and also for LDA)
    ------------------------------------------------------------------------
    DM_Inst: Data_Memory
        port map (
            Address   => instruction(7 downto 0),
            Reg_Value => rs_output,   -- If you do store, you'd set Mem_Write=1
            Mem_Write => '0',         -- always read
            Data_Out  => data_mem_out
        );

    ------------------------------------------------------------------------
    -- ALU: A=Rs, B=DataMemory
    ------------------------------------------------------------------------
    ALU_Inst: ALU
        port map (
            Opcode => alu_op,
            A      => rs_output,
            B      => data_mem_out,
            Result => alu_result
        );

    ------------------------------------------------------------------------
    -- 3-Input MUX for Register input
    ------------------------------------------------------------------------
    RegIn_Mux_Inst: RegIn_Mux
        port map (
            ALU_Out  => alu_result,
            INPR     => INPR,
            DM_Out   => data_mem_out,
            RegInSel => reg_in_sel_s,
            Reg_IN   => reg_write_data
        );

    ------------------------------------------------------------------------
    -- Output Mux
    ------------------------------------------------------------------------
    Out_Mux_Inst: Output_Mux
        port map (
            Rs   => rs_output,
            OUTR => outr_internal,
            Sel  => out_en_s
        );

    OUTR <= outr_internal;

end Behavioral;
