library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Datapath is
end tb_Datapath;

architecture test of tb_Datapath is

    signal CLK   : std_logic := '0';
    signal INPR  : std_logic_vector(15 downto 0) := (others => '0');
    signal OUTR  : std_logic_vector(15 downto 0);

    -- Reference to your Datapath entity
    component Datapath is
        Port (
            CLK   : in  STD_LOGIC;
            INPR  : in  STD_LOGIC_VECTOR(15 downto 0);
            OUTR  : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

begin

    --------------------------------------------------------------------
    -- Instantiate the Datapath
    --------------------------------------------------------------------
    DUT: Datapath
        port map (
            CLK  => CLK,
            INPR => INPR,
            OUTR => OUTR
        );

    --------------------------------------------------------------------
    -- Clock Generation: 20 ns period => 50 MHz
    --------------------------------------------------------------------
    Clock_Process: process
    begin
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
    end process;

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    Stim_Process: process
    begin
        -- 1) Provide an initial value in INPR for the first "INP" instruction
        INPR <= x"ABCD";

        -- Wait long enough to go through instructions 0..15
        wait for 3000 ns;  

        -- Optionally update INPR again to see if any new instructions read from it
        -- INPR <= x"1234";

        wait for 2000 ns;
        -- End simulation
        wait;
    end process;

end test;
