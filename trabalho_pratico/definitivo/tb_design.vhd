library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stepmotor_tb is
end stepmotor_tb;

architecture sim of stepmotor_tb is
    component stepmotor
    Port (
        clk    : in  STD_LOGIC;
        en     : in  STD_LOGIC;
        dir    : in  STD_LOGIC;
        freq   : in  STD_LOGIC;
        coil_a : out STD_LOGIC;
        coil_b : out STD_LOGIC;
        coil_c : out STD_LOGIC;
        coil_d : out STD_LOGIC
    );
    end component;

    signal clk    : STD_LOGIC := '0';
    signal en     : STD_LOGIC := '0';
    signal dir    : STD_LOGIC := '0';
    signal freq   : STD_LOGIC := '0';
    signal coil_a, coil_b, coil_c, coil_d : STD_LOGIC;

    constant CLK_PERIOD : time := 2 ns; -- 50 MHz
begin

    uut: stepmotor port map(
        clk => clk,
        en => en,
        dir => dir,
        freq => freq,
        coil_a => coil_a,
        coil_b => coil_b,
        coil_c => coil_c,
        coil_d => coil_d
    );

    -- Clock generation
    clk <= not clk after CLK_PERIOD/2;

    -- Stimulus process
    stimulus: process
    begin
        -- Initial reset
        en <= '0';
        dir <= '0';
        freq <= '0';
        wait for 100 ns;

        -- Test 1: Enable with forward direction and low speed
        en <= '1';
        dir <= '1';
        freq <= '0';
        wait for 20 ms;  -- Observe several steps in the waveform

        -- Test 2: Change direction to reverse
        dir <= '0';
        wait for 20 ms;

        -- Test 3: Increase the speed
        freq <= '1';
        dir <= '1';
        wait for 10 ms;

        -- Test 4: Disable motor
        en <= '0';
        wait for 5 ms;
        
        -- Test 2: Change direction to reverse
        dir <= '0';
        wait for 20 ms;

        -- Test 3: Increase the speed
        freq <= '1';
        dir <= '1';
        wait for 10 ms;

        -- Test 4: Disable motor
        en <= '0';
        wait for 5 ms;

        -- End simulation
        wait;
    end process;

end sim;
