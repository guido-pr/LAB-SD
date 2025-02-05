library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stepmotor is
    Port (
        clk    : in  STD_LOGIC;       -- Main clock
        en     : in  STD_LOGIC;       -- Enable motor
        dir    : in  STD_LOGIC;       -- Direction (1 = forward, 0 = reverse)
        freq   : in  STD_LOGIC;       -- Speed control
        coil_a : out STD_LOGIC;       -- Coil A
        coil_b : out STD_LOGIC;       -- Coil B
        coil_c : out STD_LOGIC;       -- Coil C
        coil_d : out STD_LOGIC        -- Coil D
    );
end stepmotor;

architecture FSM of stepmotor is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal current_state, next_state : state_type := S0;
    signal counter    : integer range 0 to 50000000 := 0;
    signal step_pulse : std_logic := '0';
begin

process(clk)
begin
    if rising_edge(clk) then
        if freq = '0' then  -- Slow speed
            if counter < 199999 then  -- 200,000 cycles @50MHz = 4ms (250Hz)
                counter <= counter + 1;
                step_pulse <= '0';
            else
                counter <= 0;
                step_pulse <= '1';
            end if;
        else  -- Fast speed
            if counter < 99999 then  -- 100,000 cycles @50MHz = 2ms (500Hz)
                counter <= counter + 1;
                step_pulse <= '0';
            else
                counter <= 0;
                step_pulse <= '1';
            end if;
        end if;
    end if;
end process;

-- FSM State Register
process(clk)
begin
    if rising_edge(clk) then
        if en = '0' then
            current_state <= S0;  -- Reset to initial state when disabled
        elsif step_pulse = '1' then
            current_state <= next_state;
        end if;
    end if;
end process;

-- FSM Next State Logic
process(current_state, dir)
begin
    case current_state is
        when S0 => 
            if dir = '1' then next_state <= S1;
            else next_state <= S7;
            end if;
            
        when S1 => 
            if dir = '1' then next_state <= S2;
            else next_state <= S0;
            end if;
            
        when S2 => 
            if dir = '1' then next_state <= S3;
            else next_state <= S1;
            end if;
            
        when S3 => 
            if dir = '1' then next_state <= S4;
            else next_state <= S2;
            end if;
            
        when S4 => 
            if dir = '1' then next_state <= S5;
            else next_state <= S3;
            end if;
            
        when S5 => 
            if dir = '1' then next_state <= S6;
            else next_state <= S4;
            end if;
            
        when S6 => 
            if dir = '1' then next_state <= S7;
            else next_state <= S5;
            end if;
            
        when S7 => 
            if dir = '1' then next_state <= S0;
            else next_state <= S6;
            end if;
    end case;
end process;

-- Output Decoder
process(current_state, en)
begin
    -- Default outputs
    coil_a <= '0'; coil_b <= '0'; coil_c <= '0'; coil_d <= '0';
    
    if en = '1' then
        case current_state is
            when S0 => coil_a <= '1';
            when S1 => coil_a <= '1'; coil_b <= '1';
            when S2 => coil_b <= '1';
            when S3 => coil_b <= '1'; coil_c <= '1';
            when S4 => coil_c <= '1';
            when S5 => coil_c <= '1'; coil_d <= '1';
            when S6 => coil_d <= '1';
            when S7 => coil_d <= '1'; coil_a <= '1';
        end case;
    end if;
end process;

end FSM;
