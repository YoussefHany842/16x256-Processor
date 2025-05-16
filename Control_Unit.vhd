library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit is
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
end Control_Unit;

architecture Behavioral of Control_Unit is
    signal SC : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Reset control signals each cycle
            BUN_EN <= '0';
            I_Read <= '0';
            Reg_Write <= '0';
            Out_EN <= '0';
            RegInSel <= "00";    -- default to ALU output
            ALU_OPCODE <= "000"; -- default to XOR

            case SC is
                when "00" =>
                    -- Fetch
                    I_Read <= '1';
                    SC <= "01";

                when "01" =>
                    -- Decode
                    SC <= "10";

                when "10" =>
                    case Opcode is
                        when "0001" =>  -- LDA
                            RegInSel <= "10";  -- Data Memory direct
                            Reg_Write <= '1';

                        when "0010" =>  -- INP
                            RegInSel <= "01";  -- INPR
                            Reg_Write <= '1';

                        when "0011" =>  -- OUT
                            Out_EN <= '1';

                        when "0100" =>  -- XOR
                            ALU_OPCODE <= "000";
                            Reg_Write <= '1';

                        when "0101" =>  -- BUN
                            BUN_EN <= '1';

                        when "0110" =>  -- AND
                            ALU_OPCODE <= "001";
                            Reg_Write <= '1';

                        when "0111" =>  -- OR
                            ALU_OPCODE <= "010";
                            Reg_Write <= '1';

                        when "1000" =>  -- NOT
                            ALU_OPCODE <= "011";
                            Reg_Write <= '1';

                        when "1001" =>  -- SHIFT LEFT
                            ALU_OPCODE <= "100";
                            Reg_Write <= '1';

                        when "1010" =>  -- SHIFT RIGHT
                            ALU_OPCODE <= "101";
                            Reg_Write <= '1';

                        ----------------------------------------------------------------
                        -- NEW ALU OPS
                        ----------------------------------------------------------------
                        when "1011" =>  -- ADD
                            ALU_OPCODE <= "110";
                            Reg_Write <= '1';

                        when "1100" =>  -- SUB
                            ALU_OPCODE <= "111";
                            Reg_Write <= '1';

                        when others =>
                            -- No-op
                            null;
                    end case;
                    SC <= "11";

                when "11" =>
                    ALU_OPCODE <= "000";  -- reset after operation
                    SC <= "00";

                when others =>
                    SC <= "00";
            end case;
        end if;
    end process;

    -- PC increments on SC="11"
    PC_INCREMENT <= '1' when SC = "11" else '0';

end Behavioral;
