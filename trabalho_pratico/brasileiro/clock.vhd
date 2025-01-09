library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div is
    Port (
        clk : in STD_LOGIC;                -- Sinal de entrada do clock
        new_clk : out STD_LOGIC           -- Sinal de saída do novo clock
    );
end clock_div;

architecture Behavioral of clock_div is
    -- Definição do fator de divisão
    constant fator_vel : unsigned(25 downto 0) := to_unsigned(25000000, 26);

    -- Registradores para contagem e saída do clock
    signal count : unsigned(25 downto 0) := (others => '0');
    signal new_clk_reg : STD_LOGIC := '0';
begin

    -- Atribuição da saída
    new_clk <= new_clk_reg;

    -- Processo principal para divisão do clock
    process(clk)
    begin
        if rising_edge(clk) then
            if count = fator_vel then
                count <= (others => '0');         -- Reinicia a contagem
                new_clk_reg <= not new_clk_reg;  -- Inverte o estado do clock
            else
                count <= count + 1;              -- Incrementa o contador
            end if;
        end if;
    end process;

end Behavioral;
