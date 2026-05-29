library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_i is
    generic (
        CYCLES_PER_BIT : integer := 50000000 -- Duração do pulso em ciclos de clock
    );
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0); -- Sequência de entrada[cite: 1]
        enable    : in  STD_LOGIC;
        nrz_i_out : out STD_LOGIC
    );
end nrz_i;

architecture Behavioral of nrz_i is
    signal bit_index     : integer range 0 to 15 := 15;
    signal cycle_cnt     : integer range 0 to CYCLES_PER_BIT - 1 := 0;
    signal is_tx         : boolean := false;
    signal current_level : STD_LOGIC := '0'; -- Armazena o nível atual do pulso
begin
    process(clk, rst)
    begin
        if rst = '1' then
            nrz_i_out     <= '0';
            current_level <= '0';
            bit_index     <= 15;
            cycle_cnt     <= 0;
            is_tx         <= false;
            
        elsif rising_edge(clk) then
            if not is_tx then
                if enable = '1' then
                    is_tx     <= true;
                    bit_index <= 15;
                    cycle_cnt <= 0;
                    
                    -- Avalia o primeiro bit: se for '1', inverte o nível[cite: 1]
                    if data_in(15) = '1' then
                        current_level <= not current_level;
                        nrz_i_out     <= not current_level;
                    else
                        nrz_i_out     <= current_level;
                    end if;
                else
                    nrz_i_out     <= '0';
                    current_level <= '0';
                end if;
            else
                -- Mantém o nível do pulso durante o intervalo do bit
                nrz_i_out <= current_level;

                if cycle_cnt = CYCLES_PER_BIT - 1 then
                    cycle_cnt <= 0;
                    
                    if bit_index = 0 then
                        is_tx <= false; -- Fim da transmissão
                    else
                        bit_index <= bit_index - 1;
                        
                        -- Avalia a transição do PRÓXIMO bit no final do ciclo atual
                        if data_in(bit_index - 1) = '1' then
                            current_level <= not current_level;
                        end if;
                    end if;
                else
                    cycle_cnt <= cycle_cnt + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;