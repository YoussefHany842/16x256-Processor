library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port (
        BUN_Address : in STD_LOGIC_VECTOR(7 downto 0);
        BUN_En      : in STD_LOGIC;
        PC_Inc      : in STD_LOGIC;
        Address     : out STD_LOGIC_VECTOR(7 downto 0)
    );
end PC;

architecture Behavioral of PC is
    signal PC_Value : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin
    process(BUN_En, PC_Inc)
    begin
        if BUN_En = '1' then
            PC_Value <= BUN_Address;
        elsif PC_Inc = '1' then
            PC_Value <= PC_Value + 1;
        end if;
    end process;

    Address <= PC_Value;

end Behavioral;

