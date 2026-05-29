library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_top is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        enable    : in  STD_LOGIC;
        -- Opcional: mantemos o LED funcionando na placa também
        nrz_l_out : out STD_LOGIC;
        
        -- Pinos do Conector VGA da Basys3
        vgaRed    : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen  : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue   : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync     : out STD_LOGIC;
        Vsync     : out STD_LOGIC
    );
end vga_top;

architecture Behavioral of vga_top is

    -- Declaração do seu módulo original
    component nrz_l is
        generic (
            CYCLES_PER_BIT : integer := 25000000 
        );
        Port (
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            data_in   : in  STD_LOGIC_VECTOR(15 downto 0);
            enable    : in  STD_LOGIC;
            nrz_l_out : out STD_LOGIC
        );
    end component;

    -- Sinal para capturar a saída do seu módulo e usar internamente
    signal nrz_signal : std_logic;
    
    -- Sinais para divisão do clock (100 MHz -> 25 MHz para VGA 640x480)
    signal clk_25     : std_logic := '0';
    signal counter_25 : unsigned(1 downto 0) := "00";

    -- Sinais do controlador VGA
    signal h_cnt    : integer range 0 to 799 := 0;
    signal v_cnt    : integer range 0 to 524 := 0;
    signal video_on : std_logic := '0';

begin

    -- Ligar o sinal do módulo interno ao LED da placa
    nrz_l_out <= nrz_signal;

    -- Instanciando o seu código original
    U_NRZ_L: nrz_l
        port map (
            clk       => clk,
            rst       => rst,
            data_in   => data_in,
            enable    => enable,
            nrz_l_out => nrz_signal
        );

    -- 1. Divisor de clock: 100MHz / 4 = 25MHz
    process(clk)
    begin
        if rising_edge(clk) then
            counter_25 <= counter_25 + 1;
            clk_25 <= counter_25(1); -- O bit 1 oscila a exatos 25MHz
        end if;
    end process;

    -- 2. Gerador de Sincronismo VGA (Padrão 640x480 @ 60Hz)
    process(clk_25, rst)
    begin
        if rst = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
            Hsync <= '1';
            Vsync <= '1';
        elsif rising_edge(clk_25) then
            -- Contador Horizontal (Pixels)
            if h_cnt = 799 then
                h_cnt <= 0;
                -- Contador Vertical (Linhas)
                if v_cnt = 524 then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;

            -- Pulso de Sincronismo Horizontal (Hsync)
            if (h_cnt >= 640 + 16) and (h_cnt < 640 + 16 + 96) then
                Hsync <= '0';
            else
                Hsync <= '1';
            end if;

            -- Pulso de Sincronismo Vertical (Vsync)
            if (v_cnt >= 480 + 10) and (v_cnt < 480 + 10 + 2) then
                Vsync <= '0';
            else
                Vsync <= '1';
            end if;
        end if;
    end process;

    -- Identifica quando o "feixe de luz" está na área visível do monitor
    video_on <= '1' when (h_cnt < 640 and v_cnt < 480) else '0';

    -- 3. Gerador de Imagem baseado na modulação NRZ-L
    process(video_on, v_cnt, nrz_signal)
    begin
        -- Define cor preta por padrão
        vgaRed   <= (others => '0');
        vgaGreen <= (others => '0');
        vgaBlue  <= (others => '0');

        if video_on = '1' then
            -- Se a saída modulada for '1'
            if nrz_signal = '1' then
                -- Desenha uma barra VERDE espessa na metade SUPERIOR da tela
                if v_cnt >= 120 and v_cnt < 240 then
                    vgaGreen <= "1111"; 
                else
                    vgaBlue <= "0001"; -- Fundo azul muito escuro no resto
                end if;
                
            -- Se a saída modulada for '0'
            else
                -- Desenha uma barra VERMELHA espessa na metade INFERIOR da tela
                if v_cnt >= 240 and v_cnt < 360 then
                    vgaRed <= "1111";
                else
                    vgaBlue <= "0001"; -- Fundo azul muito escuro no resto
                end if;
            end if;
        end if;
    end process;

end Behavioral;