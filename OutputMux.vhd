library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Output_Mux is
    Port (
        Rs    : in  STD_LOGIC_VECTOR(15 downto 0);
        OUTR  : out STD_LOGIC_VECTOR(15 downto 0);
        Sel   : in  STD_LOGIC
    );
end Output_Mux;

architecture Behavioral of Output_Mux is
begin
    process(Sel, Rs)
    begin
        if Sel = '0' then
            OUTR <= Rs;
        end if;
    end process;
end Behavioral;