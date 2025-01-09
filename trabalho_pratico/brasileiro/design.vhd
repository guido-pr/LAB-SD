library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mcd_step_driver is
    Port (
        rst : in STD_LOGIC;                 -- Reset
        dir : in STD_LOGIC;                 -- Direção
        clk : in STD_LOGIC;                 -- Clock
        en : in STD_LOGIC;                  -- Enable
        signal : out STD_LOGIC_VECTOR(3 downto 0) -- Sinal de saída
    );
end mcd_step_driver;

architecture Behavioral of mcd_step_driver is

    -- Definição dos estados
    type state_type is (sig4, sig3, sig2, sig1, sig0);
    signal present_state, next_state : state_type;

begin

    -- Processo de controle de transições entre estados
    state_transition : process(clk, rst)
    begin
        if rst = '1' then
            present_state <= sig0; -- Estado inicial no reset
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

    -- Lógica para determinar o próximo estado
    next_state_logic : process(present_state, dir, en)
    begin
        case present_state is
            when sig4 =>
                if dir = '0' and en = '1' then
                    next_state <= sig3;
                elsif dir = '1' and en = '1' then
                    next_state <= sig1;
                else
                    next_state <= sig0;
                end if;

            when sig3 =>
                if dir = '0' and en = '1' then
                    next_state <= sig2;
                elsif dir = '1' and en = '1' then
                    next_state <= sig4;
                else
                    next_state <= sig0;
                end if;

            when sig2 =>
                if dir = '0' and en = '1' then
                    next_state <= sig1;
                elsif dir = '1' and en = '1' then
                    next_state <= sig3;
                else
                    next_state <= sig0;
                end if;

            when sig1 =>
                if dir = '0' and en = '1' then
                    next_state <= sig4;
                elsif dir = '1' and en = '1' then
                    next_state <= sig2;
                else
                    next_state <= sig0;
                end if;

            when sig0 =>
                if en = '1' then
                    next_state <= sig1;
                else
                    next_state <= sig0;
                end if;

            when others =>
                next_state <= sig0;
        end case;
    end process;

    -- Processo para gerar os sinais de saída
    output_logic : process(clk)
    begin
        if rising_edge(clk) then
            case present_state is
                when sig4 => signal <= "1000";
                when sig3 => signal <= "0100";
                when sig2 => signal <= "0010";
                when sig1 => signal <= "0001";
                when others => signal <= "0000";
            end case;
        end if;
    end process;

end Behavioral;
