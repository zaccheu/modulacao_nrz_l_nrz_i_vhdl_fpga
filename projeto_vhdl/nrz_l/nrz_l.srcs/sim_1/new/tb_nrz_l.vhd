library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_nrz_l is
end tb_nrz_l;

architecture sim of tb_nrz_l is

    -- Configuração do clock e unidade de tempo do pulso[cite: 1]
    constant CLK_PERIOD     : time := 5 ns;
    constant CYCLES_PER_BIT : integer := 4;
    constant BIT_PERIOD     : time := CLK_PERIOD * CYCLES_PER_BIT; -- Resulta em 20 ns[cite: 1]

    -- Sinais de interface
    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '1';
    signal data_in   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal enable    : STD_LOGIC := '0';
    signal nrz_l_out : STD_LOGIC;

begin

    -- Instanciação do módulo NRZ-L principal
    DUT: entity work.nrz_l
        generic map (
            CYCLES_PER_BIT => CYCLES_PER_BIT
        )
        port map (
            clk       => clk,
            rst       => rst,
            data_in   => data_in,
            enable    => enable,
            nrz_l_out => nrz_l_out
        );

    -- Geração do Clock contínuo
    clk <= not clk after CLK_PERIOD / 2;

    -- Processo de estímulos da simulação
    process
    begin
        -- Estado inicial de Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Carrega o vetor de bits na entrada[cite: 1]
        data_in <= "1011001011010011"; 
        
        -- Inicia a transmissão
        enable <= '1';
        wait for CLK_PERIOD;
        enable <= '0';

        -- Aguarda o fim da transmissão de todos os 16 bits
        wait for BIT_PERIOD * 16;
        
        -- Intervalo final
        wait for 50 ns;
        
        -- Encerra a simulação
        wait;
    end process;

end sim;