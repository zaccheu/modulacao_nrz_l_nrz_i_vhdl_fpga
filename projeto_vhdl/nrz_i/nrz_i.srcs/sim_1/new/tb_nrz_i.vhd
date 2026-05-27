library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_nrz_i is
end tb_nrz_i;

architecture sim of tb_nrz_i is

    constant CLK_PERIOD     : time := 5 ns;
    constant CYCLES_PER_BIT : integer := 4;
    constant BIT_PERIOD     : time := CLK_PERIOD * CYCLES_PER_BIT; -- Duração de 20 ns[cite: 1]

    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '1';
    signal data_in   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal enable    : STD_LOGIC := '0';
    signal nrz_i_out : STD_LOGIC;

begin

    DUT: entity work.nrz_i
        generic map (
            CYCLES_PER_BIT => CYCLES_PER_BIT
        )
        port map (
            clk       => clk,
            rst       => rst,
            data_in   => data_in,
            enable    => enable,
            nrz_i_out => nrz_i_out
        );

    clk <= not clk after CLK_PERIOD / 2;

    process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Mesma sequência de bits para facilitar a comparação entre NRZ-L e NRZ-I[cite: 1]
        data_in <= "1011001011010011"; 
        
        enable <= '1';
        wait for CLK_PERIOD;
        enable <= '0';

        wait for BIT_PERIOD * 16;
        wait for 50 ns;
        
        wait;
    end process;

end sim;