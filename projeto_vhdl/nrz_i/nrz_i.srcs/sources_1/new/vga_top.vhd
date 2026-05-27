library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_top is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        enable    : in  STD_LOGIC;
        
        -- Atualizado para o nome do novo módulo (para o LED da placa)
        nrz_i_out : out STD_LOGIC; 
        
        -- Pinos do Conector VGA
        vgaRed    : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen  : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue   : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync     : out STD_LOGIC;
        Vsync     : out STD_LOGIC
    );
end vga_top;

architecture Behavioral of vga_top is

    -- Declaração do NOVO módulo (NRZ-I)
    component nrz_i is
        generic (
            CYCLES_PER_BIT : integer := 50000000 
        );
        Port (
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
            enable    : in  STD_LOGIC;
            nrz_i_out : out STD_LOGIC
        );
    end component;

    signal nrz_signal : std_logic;
    
    -- Sinais para divisão do clock (100 MHz -> 25 MHz para VGA)
    signal clk_25     : std_logic := '0';
    signal counter_25 : unsigned(1 downto 0) := "00";

    -- Sinais do controlador VGA
    signal h_cnt    : integer range 0 to 799 := 0;
    signal v_cnt    : integer range 0 to 524 := 0;
    signal video_on : std_logic := '0';

begin

    -- Liga o sinal interno à saída do LED
    nrz_i_out <= nrz_signal;

    -- Instanciando o NOVO código
    U_NRZ_I: nrz_i
        port map (
            clk       => clk,
            rst       => rst,
            data_in   => data_in,
            enable    => enable,
            nrz_i_out => nrz_signal -- O sinal de saída agora vem do nrz_i
        );

    -- 1. Divisor de clock: 100MHz / 4 = 25MHz
    process(clk)
    begin
        if rising_edge(clk) then
            counter_25 <= counter_25 + 1;
            clk_25 <= counter_25(1);
        end if;
    end process;

    -- 2. Gerador de Sincronismo VGA
    process(clk_25, rst)
    begin
        if rst = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
            Hsync <= '1';
            Vsync <= '1';
        elsif rising_edge(clk_25) then
            if h_cnt = 799 then
                h_cnt <= 0;
                if v_cnt = 524 then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;

            if (h_cnt >= 640 + 16) and (h_cnt < 640 + 16 + 96) then
                Hsync <= '0';
            else
                Hsync <= '1';
            end if;

            if (v_cnt >= 480 + 10) and (v_cnt < 480 + 10 + 2) then
                Vsync <= '0';
            else
                Vsync <= '1';
            end if;
        end if;
    end process;

    video_on <= '1' when (h_cnt < 640 and v_cnt < 480) else '0';

    -- 3. Gerador de Imagem (Lê o 'nrz_signal' que agora vem do NRZ-I)
    process(video_on, v_cnt, nrz_signal)
    begin
        vgaRed   <= (others => '0');
        vgaGreen <= (others => '0');
        vgaBlue  <= (others => '0');

        if video_on = '1' then
            if nrz_signal = '1' then
                if v_cnt >= 120 and v_cnt < 240 then
                    vgaGreen <= "1111"; 
                else
                    vgaBlue <= "0001";
                end if;
            else
                if v_cnt >= 240 and v_cnt < 360 then
                    vgaRed <= "1111";
                else
                    vgaBlue <= "0001";
                end if;
            end if;
        end if;
    end process;

end Behavioral;