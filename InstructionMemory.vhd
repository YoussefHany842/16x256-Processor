library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_Memory is
    Port (
        Address  : in  STD_LOGIC_VECTOR(7 downto 0);
        I_Read   : in  STD_LOGIC;
        Data_Out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    type Memory_Array is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
    signal ROM : Memory_Array := (
        -- Existing instructions 0..12 for old ops
        0  => x"2000",  -- INP
        1  => x"3000",  -- OUT
        2  => x"4005",  -- XOR #5
        3  => x"3000",  -- OUT
        4  => x"6002",  -- AND #2
        5  => x"3000",  -- OUT
        6  => x"1005",  -- LDA #5
        7  => x"7001",  -- OR #1
        8  => x"3000",  -- OUT
        9  => x"8000",  -- NOT
        10 => x"9000",  -- SHIFT LEFT
        11 => x"A000",  -- SHIFT RIGHT
        12 => x"3000",  -- OUT

        -- New instructions for ADD/SUB:
        13 => x"B005",  -- ADD #5  => (1011 + address=5)
        14 => x"C005",  -- SUB #5  => (1100 + address=5)
        15 => x"3000",  -- OUT

        others => (others => '0')
    );
begin
    process(Address, I_Read)
    begin
        if I_Read = '1' then
            Data_Out <= ROM(CONV_INTEGER(Address));
        end if;
    end process;
end Behavioral;
