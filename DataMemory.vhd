library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Data_Memory is
    Port (
        Address   : in  STD_LOGIC_VECTOR(7 downto 0);
        Reg_Value : in  STD_LOGIC_VECTOR(15 downto 0);
        Mem_Write : in  STD_LOGIC;
        Data_Out  : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Data_Memory;

architecture Behavioral of Data_Memory is
    type Memory_Array is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
    signal RAM : Memory_Array := (
        0 => x"0000",
        1 => x"0001",
        2 => x"0002",
        3 => x"0003",
        4 => x"0004",
        5 => x"00FF",  -- used often
        others => (others => '0')
    );
begin
    process(Address, Mem_Write, Reg_Value)
    begin
        if Mem_Write = '1' then
            RAM(CONV_INTEGER(Address)) <= Reg_Value;
        end if;
        Data_Out <= RAM(CONV_INTEGER(Address));
    end process;
end Behavioral;
