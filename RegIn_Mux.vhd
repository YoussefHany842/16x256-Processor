library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegIn_Mux is
    Port (
        INPR     : in  STD_LOGIC_VECTOR(15 downto 0);
        ALU_Out  : in  STD_LOGIC_VECTOR(15 downto 0);
        DM_Out   : in  STD_LOGIC_VECTOR(15 downto 0);   -- new
        RegInSel : in  STD_LOGIC_VECTOR(1 downto 0);    -- now 2 bits
        Reg_IN   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end RegIn_Mux;


architecture Behavioral of RegIn_Mux is
begin
    process(RegInSel, INPR, ALU_Out, DM_Out)
    begin
        case RegInSel is
            when "00" =>
                Reg_IN <= ALU_Out;      -- e.g. ALU result
            when "01" =>
                Reg_IN <= INPR;         -- input from INPR
            when "10" =>
                Reg_IN <= DM_Out;       -- data memory output
            when others =>
                -- default or unused
                Reg_IN <= (others => '0');
        end case;
    end process;
end Behavioral;

