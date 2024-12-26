library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Prova_tb is
end Prova_tb;

architecture behavior of Prova_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component prova
        generic (
            W : integer := 1
        );
        port (
            clock : in std_logic;
            p, z : in std_logic;
            verde1, vermelho1, amarelo1, pdverde1, pdvermelho1 : out std_logic_vector(W - 1 downto 0);
            verde2, vermelho2, amarelo2, pdverde2, pdvermelho2 : out std_logic_vector(W - 1 downto 0)
        );
    end component;

    -- Testbench signals
    signal clock : std_logic := '0';
    signal p, z : std_logic := '0';
    signal verde1, vermelho1, amarelo1, pdverde1, pdvermelho1 : std_logic_vector(0 downto 0);
    signal verde2, vermelho2, amarelo2, pdverde2, pdvermelho2 : std_logic_vector(0 downto 0);

    constant clock_period : time := 2 sec;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: prova
        generic map (
            W => 1
        )
        port map (
            clock => clock,
            p => p,
            z => z,
            verde1 => verde1,
            vermelho1 => vermelho1,
            amarelo1 => amarelo1,
            pdverde1 => pdverde1,
            pdvermelho1 => pdvermelho1,
            verde2 => verde2,
            vermelho2 => vermelho2,
            amarelo2 => amarelo2,
            pdverde2 => pdverde2,
            pdvermelho2 => pdvermelho2
        );

    -- Clock process
    clock_process : process
    begin
        while true loop
            clock <= '0';
            wait for clock_period/2;
            clock <= '1';
            wait for clock_period/2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Initialize inputs
        p <= '0';
        z <= '0';
        wait for 5 sec;

        -- Test state transitions
        p <= '1';
        wait for 2 sec;
        
        p <= '0';
        wait for 25 sec;
        
        z <= '1';
        wait for 2 sec;
        
        z <= '0';
        wait for 100 sec;

        -- Finish simulation
    end process;

end behavior;
