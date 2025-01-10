library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stepmotor is
    Port (
        clk : in STD_LOGIC;
        M : out STD_LOGIC_VECTOR(3 downto 0);
        B : out STD_LOGIC_VECTOR(3 downto 0)
    );
end stepmotor;

architecture FSM of stepmotor is
    -- Definição dos estados
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal current_state, next_state : state_type;

    -- Registro de saída
    signal M_reg, B_reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

    -- Clock dividido
    signal clk_1 : STD_LOGIC;

begin
    -- Atribuir os sinais de saída
    M <= M_reg;
    B <= B_reg;

    -- Instância do módulo de divisão de clock
    div_instance: entity work.clock
        port map (
            clk => clk,
            clk_1 => clk_1
        );

    -- Processo de atualização do estado
    process(clk_1)
    begin
        if rising_edge(clk_1) then
            current_state <= next_state;
        end if;
    end process;

    -- Processo de definição da lógica da máquina de estados
    process(current_state)
    begin
        -- Inicializar os valores padrão
        M_reg <= (others => '0');
        B_reg <= (others => '0');
        next_state <= current_state;

        case current_state is
            when S0 =>
                M_reg <= "0001";
                B_reg <= "1001";
                next_state <= S1;
            when S1 =>
                M_reg <= "0010";
                B_reg <= "1000";
                next_state <= S2;
            when S2 =>
                M_reg <= "0100";
                B_reg <= "1100";
                next_state <= S3;
            when S3 =>
                M_reg <= "1000";
                B_reg <= "0100";
                next_state <= S4;
            when S4 =>
                M_reg <= "1000";
                B_reg <= "0010";
                next_state <= S5;
            when S5 =>
                M_reg <= "1100";
                B_reg <= "0001";
                next_state <= S6;
            when S6 =>
                M_reg <= "0110";
                B_reg <= "0001";
                next_state <= S7;
            when S7 =>
                M_reg <= "0011";
                B_reg <= "0001";
                next_state <= S0;
            when others =>
                next_state <= S0;
        end case;
    end process;

end FSM;
