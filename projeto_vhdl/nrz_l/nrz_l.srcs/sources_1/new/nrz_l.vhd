library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_l is
    generic (
        -- Duração do pulso definida em função do número de ciclos de clock
        CYCLES_PER_BIT : integer := 25000000 
    );
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0); -- Entrada de vetor de bits equivalente aos switches
        enable    : in  STD_LOGIC;                     -- Pulso para iniciar a transmissão
        nrz_l_out : out STD_LOGIC                      -- Saída modulada
    );
end nrz_l;

architecture Behavioral of nrz_l is
    signal bit_index : integer range 0 to 15 := 15;
    signal cycle_cnt : integer range 0 to CYCLES_PER_BIT - 1 := 0;
    signal is_tx     : boolean := false;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            nrz_l_out <= '0';
            bit_index <= 15;
            cycle_cnt <= 0;
            is_tx     <= false;
            
        elsif rising_edge(clk) then
            if not is_tx then
                if enable = '1' then
                    is_tx     <= true;
                    bit_index <= 15; -- Inicia do bit mais significativo (MSB)
                    cycle_cnt <= 0;
                else
                    nrz_l_out <= '0';
                end if;
            else
                -- Modulação Unipolar NRZ-L: bit dita diretamente o nível do pulso[cite: 1]
                nrz_l_out <= data_in(bit_index);

                -- Lógica para controle da duração do bit no tempo discretizado
                if cycle_cnt = CYCLES_PER_BIT - 1 then
                    cycle_cnt <= 0;
                    if bit_index = 0 then
                        is_tx <= false; -- Conclui envio do vetor
                    else
                        bit_index <= bit_index - 1; -- Próximo bit
                    end if;
                else
                    cycle_cnt <= cycle_cnt + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;