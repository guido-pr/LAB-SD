library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity topMotor is
    Port (
        clk : in STD_LOGIC;
        M : out STD_LOGIC_VECTOR(3 downto 0);
        B : out STD_LOGIC_VECTOR(3 downto 0)
    );
end topMotor;

architecture Behavioral of topMotor is
    signal cont : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal clk_1 : STD_LOGIC;
    signal M_reg, B_reg : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin

    -- Atribuir sinais de saída às variáveis internas
    M <= M_reg;
    B <= B_reg;

    -- Instância do módulo de divisão de clock (div_m)
    div_instance: entity work.div_m
        port map (
            clk => clk,
            clk_1 => clk_1
        );

    -- Processo sensível ao clk_1
    process(clk_1)
    begin
        if rising_edge(clk_1) then
            case cont is
                when "000" =>
                    M_reg <= "0001";
                    B_reg <= "1001";
                when "001" =>
                    M_reg <= "0010";
                    B_reg <= "1000";
                when "010" =>
                    M_reg <= "0100";
                    B_reg <= "1100";
                when "011" =>
                    M_reg <= "1000";
                    B_reg <= "0100";
                when "100" =>
                    M_reg <= "1000";
                    B_reg <= "0010";
                when "101" =>
                    M_reg <= "1100";
                    B_reg <= "0001";
                when "110" =>
                    M_reg <= "0110";
                    B_reg <= "0001";
                when "111" =>
                    M_reg <= "0011";
                    B_reg <= "0001";
                when others =>
                    cont <= "000";
            end case;

            -- Incrementar o contador
            cont <= STD_LOGIC_VECTOR(unsigned(cont) + 1);
        end if;
    end process;

end Behavioral;
