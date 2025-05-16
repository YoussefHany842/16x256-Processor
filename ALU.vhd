library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;       -- Allows A+B on std_logic_vector
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- If you want +, - on std_logic_vector

entity ALU is
    Port (
        Opcode : in  STD_LOGIC_VECTOR(2 downto 0);
        A      : in  STD_LOGIC_VECTOR(15 downto 0);
        B      : in  STD_LOGIC_VECTOR(15 downto 0);
        Result : out STD_LOGIC_VECTOR(15 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(Opcode, A, B)
    begin
        case Opcode is
            when "000" =>
                -- XOR
                Result <= A xor B;

            when "001" =>
                -- AND
                Result <= A and B;

            when "010" =>
                -- OR
                Result <= A or B;

            when "011" =>
                -- NOT (unary on A, ignoring B)
                Result <= not A;

            when "100" =>
                -- SHIFT LEFT by 1 (bit slicing)
                Result(15 downto 1) <= A(14 downto 0);
                Result(0) <= '0';

            when "101" =>
                -- SHIFT RIGHT by 1 (bit slicing)
                Result(14 downto 0) <= A(15 downto 1);
                Result(15) <= '0';

            when "110" =>
                -- ADD
                -- Using std_logic_arith => we can do A + B directly
                Result <= A + B;

            when "111" =>
                -- SUB
                -- Using std_logic_arith => we can do A - B
                Result <= A - B;

            when others =>
                -- Default
                Result <= (others => '0');
        end case;
    end process;
end Behavioral;
