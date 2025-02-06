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

    constant CLK_PERIOD : time := 20 ns; -- 50 MHz
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

    -- Geração de clock
    clk <= not clk after CLK_PERIOD/2;

    -- Processo de estímulo
    stimulus: process
    begin
        -- Reset inicial
        en <= '0';
        dir <= '0';
        freq <= '0';
        wait for 100 ns;

        -- Teste 1: Ativação com direção forward e baixa velocidade
        en <= '1';
        dir <= '1';
        freq <= '0';
        wait for 32 ms;  -- Verificar vários passos no waveform

        -- Teste 2: Mudança de direção para reverse
        dir <= '0';
        wait for 32 ms;

        -- Teste 3: Aumento da velocidade
        freq <= '1';
        dir <= '1';
        wait for 16 ms;

        -- Teste 4: Desativar motor
        en <= '0';
        wait for 5 ms;

        -- Finalizar simulação
        wait;
    end process;

end sim;
