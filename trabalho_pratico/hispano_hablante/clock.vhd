library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity div_m is
    Port (
        clk : in STD_LOGIC;             -- Entrada de clock
        clk_1 : out STD_LOGIC           -- Saída de clock dividido
    );
end div_m;

architecture Behavioral of div_m is
    signal cont : UNSIGNED(27 downto 0) := (others => '0');  -- Contador de 28 bits
    signal clk_1_reg : STD_LOGIC := '0';                    -- Sinal interno para clk_1
begin

    -- Atribuir o valor interno de clk_1 à saída
    clk_1 <= clk_1_reg;

    -- Processo sensível à borda de subida de clk
    process(clk)
    begin
        if rising_edge(clk) then
            -- Incrementar o contador
            cont <= cont + 1;

            -- Verificar se o contador atingiu 500.000
            if cont = 500000 then
                cont <= (others => '0');         -- Reiniciar o contador
                clk_1_reg <= not clk_1_reg;     -- Inverter o valor de clk_1
            end if;
        end if;
    end process;

end Behavioral;
