library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prova is
    generic (
        W : integer := 1
    );
    port (
        clock : in std_logic; 
        p, z  : in std_logic; 
        verde1, vermelho1, amarelo1, pdverde1, pdvermelho1,
        verde2, vermelho2, amarelo2, pdverde2, pdvermelho2 : out std_logic_vector(W - 1 downto 0)
    );
end prova;

architecture behavior of prova is
    -- Declarações
    type state_type is (s1, s2, sw21, sw22, sw23, sw24, s3, s4, sw41, sw42, sw43, s5);
    signal y : state_type := s1;

    -- Variáveis para o clock de 2 segundos
    constant CLK_FREQ : integer := 50000000; -- Frequência do clock principal (50 MHz)
    constant MAX_COUNT : integer := CLK_FREQ - 1; -- Contagem para 2 segundos
    signal counter : integer := 0;
    signal slow_clock : std_logic := '0'; -- Clock lento
begin
    -- Divisor de clock
    process (clock)
    begin
        if (clock'event and clock = '1') then
            if counter = MAX_COUNT then
                counter <= 0;
                slow_clock <= not slow_clock; -- Alterna o clock lento
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Máquina de estados usando o clock lento
    process (slow_clock)
    begin
        if (slow_clock'event and slow_clock = '1') then
            case y is
                when s1 =>
                    if (p = '1' or z = '1') then
                        y <= s2;
                    else
                        y <= s1;
                    end if;
                when s2 =>
                    y <= sw21;
                when sw21 =>
                    y <= sw22;
                when sw22 =>
                    y <= sw23;
                when sw23 =>
                    y <= sw24;
                when sw24 =>
                    y <= s3;
                when s3 =>
                    y <= s4;
                when s4 =>
                    y <= sw41;
                when sw41 =>
                    y <= sw42;
                when sw42 =>
                    y <= sw43;
                when sw43 =>
                    y <= s5;
                when s5 =>
                    y <= s1;
            end case;
        end if;
    end process;

    -- Saídas baseadas no estado atual
    process (y)
    begin
        case y is
            when s1 =>
                verde1      <= "1";
                vermelho1   <= "0";
                amarelo1    <= "0";
                pdverde1    <= "0";
                pdvermelho1 <= "1";
                verde2      <= "0";
                vermelho2   <= "1";
                amarelo2    <= "0";
                pdverde2    <= "1";
                pdvermelho2 <= "0";

            when s2 | sw21 | sw22 | sw23 | sw24 =>
                verde1      <= "1";
                vermelho1   <= "0";
                amarelo1    <= "0";
                pdverde1    <= "0";
                pdvermelho1 <= "1";
                verde2      <= "0";
                vermelho2   <= "1";
                amarelo2    <= "0";
                pdverde2    <= "1";
                pdvermelho2 <= "0";

            when s3 =>
                verde1      <= "0";
                vermelho1   <= "0";
                amarelo1    <= "1";
                pdverde1    <= "0";
                pdvermelho1 <= "1";
                verde2      <= "0";
                vermelho2   <= "1";
                amarelo2    <= "0";
                pdverde2    <= "1";
                pdvermelho2 <= "0";

            when s4 | sw41 | sw42 | sw43 =>
                verde1      <= "0";
                vermelho1   <= "1";
                amarelo1    <= "0";
                pdverde1    <= "1";
                pdvermelho1 <= "0";
                verde2      <= "1";
                vermelho2   <= "0";
                amarelo2    <= "0";
                pdverde2    <= "0";
                pdvermelho2 <= "1";

            when s5 =>
                verde1      <= "0";
                vermelho1   <= "1";
                amarelo1    <= "0";
                pdverde1    <= "1";
                pdvermelho1 <= "0";
                verde2      <= "0";
                vermelho2   <= "0";
                amarelo2    <= "1";
                pdverde2    <= "0";
                pdvermelho2 <= "1";

            when others =>
                verde1      <= "0";
                vermelho1   <= "0";
                amarelo1    <= "0";
                pdverde1    <= "0";
                pdvermelho1 <= "0";
                verde2      <= "0";
                vermelho2   <= "0";
                amarelo2    <= "0";
                pdverde2    <= "0";
                pdvermelho2 <= "0";
        end case;
    end process;
end behavior;
