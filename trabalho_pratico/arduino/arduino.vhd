# TESTE1:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MotorControl is
    Port (
        clk        : in  STD_LOGIC; -- Clock do sistema
        reset      : in  STD_LOGIC; -- Sinal de reset
        motor_port : out STD_LOGIC_VECTOR(3 downto 0) -- Saída do motor (equivalente ao PORTB[3:0])
    );
end MotorControl;

architecture Behavioral of MotorControl is
    -- Constantes para os bytes das fases do motor
    constant HOR : STD_LOGIC_VECTOR(3 downto 0) := "1001"; -- 0x09
    constant AHO : STD_LOGIC_VECTOR(3 downto 0) := "1000"; -- 0x08

    -- Matriz das fases
    type fase_array is array(0 to 7) of STD_LOGIC_VECTOR(3 downto 0);
    constant HOR_MATRIX : fase_array := (
        "1001", "0001", "0011", "0010", "0110", "0100", "1100", "1000"
    );
    constant AHO_MATRIX : fase_array := (
        "1000", "1100", "0100", "0110", "0010", "0011", "0001", "1001"
    );

    -- Constantes de tempo
    constant atraso_fase : integer := 1_000; -- Atraso entre fases (em ciclos de clock)
    constant intervalo    : integer := 1_000_000; -- Intervalo entre os movimentos (em ciclos de clock)

    -- Sinais internos
    signal i, j     : integer range 0 to 511 := 0;
    signal fase_idx : integer range 0 to 7 := 0;
    signal delay_counter : integer := 0;
    signal direction : STD_LOGIC := '0'; -- 0 para HOR, 1 para AHO
begin
    process(clk, reset)
    begin
        if reset = '1' then
            motor_port <= (others => '0');
            i <= 0;
            j <= 0;
            fase_idx <= 0;
            delay_counter <= 0;
            direction <= '0';
        elsif rising_edge(clk) then
            if delay_counter < atraso_fase then
                delay_counter <= delay_counter + 1;
            else
                delay_counter <= 0;

                -- Atualizar fase
                if direction = '0' then
                    motor_port <= HOR_MATRIX(fase_idx);
                else
                    motor_port <= AHO_MATRIX(fase_idx);
                end if;

                -- Incrementar índices
                if fase_idx < 7 then
                    fase_idx <= fase_idx + 1;
                else
                    fase_idx <= 0;
                    if i < 511 then
                        i <= i + 1;
                    else
                        i <= 0;
                        if direction = '0' then
                            direction <= '1'; -- Trocar direção
                        else
                            direction <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;



# TESTE2:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MotorControl is
    Port (
        clk         : in  std_logic;       -- Clock do sistema
        reset       : in  std_logic;       -- Sinal de reset
        motor_port  : out std_logic_vector(3 downto 0)  -- Porta para controlar o motor
    );
end MotorControl;

architecture Behavioral of MotorControl is
    type byte_array is array (0 to 7) of std_logic_vector(3 downto 0);
    constant HOR : byte_array := (
        "1001", "0001", "0011", "0010", "0110", "0100", "1100", "1000"
    ); -- Sentido horário
    constant AHO : byte_array := (
        "1000", "1100", "0100", "0110", "0010", "0011", "0001", "1001"
    ); -- Sentido anti-horário

    constant atraso_fase : time := 1 ms;  -- Intervalo entre fases
    constant intervalo : time := 1000 ms; -- Intervalo entre movimentos

    signal i : integer range 0 to 511 := 0; -- Contador de passos
    signal j : integer range 0 to 7 := 0;   -- Contador de fases
    signal dir : std_logic := '0'; -- Direção: '0' = horário, '1' = anti-horário
begin
    process (clk, reset)
        variable atraso : time := atraso_fase;
    begin
        if reset = '1' then
            i <= 0;
            j <= 0;
            motor_port <= (others => '0');
            dir <= '0';
        elsif rising_edge(clk) then
            if i < 512 then
                if dir = '0' then
                    motor_port <= HOR(j);
                else
                    motor_port <= AHO(j);
                end if;

                -- Avança para a próxima fase
                if j < 7 then
                    j <= j + 1;
                else
                    j <= 0;
                    i <= i + 1;
                end if;

                -- Atraso entre fases
                wait for atraso_fase;
            else
                -- Intervalo entre movimentos
                wait for intervalo;
                i <= 0;
                j <= 0;
                dir <= not dir; -- Troca a direção
            end if;
        end if;
    end process;
end Behavioral;
