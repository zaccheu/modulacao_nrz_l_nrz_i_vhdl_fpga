# Modulação NRZ-I

Implementação em VHDL da modulação **Unipolar NRZ-I**, em que o bit é representado pela transição do pulso no início do intervalo de bit (1 = inversão do nível, 0 = mantém o nível anterior).

Na modulação NRZ-I (*Non-Return-to-Zero Inverted*), a informação está codificada nas transições do sinal, e não no nível absoluto. Ao receber o bit `1`, o nível do pulso é invertido em relação ao anterior; ao receber o bit `0`, o nível é mantido. Um flip-flop interno (`current_level`) armazena o estado anterior para essa lógica.

## Estrutura desta pasta

```
nrz_i/                      Projeto da modulação NRZ-L (auto-contido)
├── cache/                  Arquivos temporários/cache do Vivado.
├── hw/                     Arquivos usados para programar/debugar a FPGA.
├── ipuser/                 Arquivos gerados por blocos IP do Vivado.
├── runs/                   Resultado da implementação física na FPGA
├── sim/					Projeto Vivado pronto para abrir
├─- srcs/                   Código-fonte VHDL do circuito
└── constraints/            Mapeamento dos pinos da FPGA (.xdc)
```

## Arquivos de código

| Arquivo										 | Descrição																																																							     |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `srcs/sources_1/new/_nrz_i.vhd`				 | Código-fonte do circuito principal. Recebe 16 bits pelos switches e gera o sinal modulado NRZ-L no LED. Utiliza o generic `CYCLES_PER_BIT` (padrão: 25.000.000 ciclos = 0,25 s por bit a 100 MHz) para controlar a duração de cada pulso. |
| `srcs/sim_1/new/tb_nrz_i.vhd`					 | Testbench para simulação comportamental. Aplica uma sequência definida na placa `BASYS 3` com `CYCLES_PER_BIT = 25.000.000` (período de 250 ms por bit) para verificação rápida no waveform.												 |
| `srcs/constrs_1/imports/Constraints/nrz_i.xdc` | Arquivo de constraints para a placa Basys3 rev B. Mapeia os 16 switches para `data_in`, o LED LD0 para `nrz_i_out`, BTNC para `enable` e BTNU para `rst`. Inclui mapeamento do conector VGA para o extra.							     |

## Documentação

- [Tutorial de simulação](./docs/tutorial_simulacao.pdf) — como simular no Vivado passo a passo
- [Tutorial de gravação na placa](./docs/tutorial_placa.pdf) — como sintetizar, gerar bitstream e gravar na FPGA
- [Documentação técnica](./docs/documentacao_projeto.pdf) — diagrama de blocos, descrição das portas e funcionamento

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):

1. Abrir o Vivado e carregar `projeto_vhdl/nrz_i/nrz_i.xpr`
2. Clicar em `Generate Bitstream` → `Open Hardware Manager` → `Open Target` → `Auto Connect` → `Program Device`

Para **reproduzir o projeto do zero**, siga esta ordem:

1. **Entenda o circuito** lendo a [documentação técnica](./docs/documentacao_projeto.pdf)
2. **Simule no Vivado** seguindo o [tutorial de simulação](./docs/tutorial_simulacao.pdf)
3. **Grave na placa** seguindo o [tutorial de gravação](./docs/tutorial_placa.pdf)
4. (Opcional) Explore os [extras](./extras/) — saída VGA

## Extras (opcionais)

- ✅ [Saída VGA com cores pulsantes](./extras/vga/) — a tela exibe uma barra verde (nível alto) ou barra vermelha (nível baixo) conforme o sinal modulado, com fundo azul escuro. Implementado no módulo `vga_top.vhd` que instancia o `nrz_i` internamente.
