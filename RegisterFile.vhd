library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterFile is
    Port (
        CLK        : in  STD_LOGIC; -- Check for CLK
        Rs_Address : in  STD_LOGIC_VECTOR(1 downto 0);
        Rd_Address : in  STD_LOGIC_VECTOR(1 downto 0);
        Reg_Write  : in  STD_LOGIC;
        Data_In    : in  STD_LOGIC_VECTOR(15 downto 0);
        Rs         : out STD_LOGIC_VECTOR(15 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type Reg_Array is array(0 to 3) of STD_LOGIC_VECTOR(15 downto 0);
    signal Regs : Reg_Array;
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if Reg_Write = '1' then
                Regs(CONV_INTEGER(unsigned(Rd_Address))) <= Data_In;
            end if;
        end if;
    end process;

    -- Read Rs
    Rs <= Regs(CONV_INTEGER(unsigned(Rs_Address)));
end Behavioral;
