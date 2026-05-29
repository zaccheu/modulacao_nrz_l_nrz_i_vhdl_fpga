# Modulação NRZ-L

Implementação em VHDL da modulação **Unipolar NRZ-L**, em que o bit é representado pelo nível do pulso durante todo o intervalo de bit (1 = nível alto, 0 = nível baixo).

Na modulação NRZ-L (*Non-Return-to-Zero Level*), cada bit da sequência de entrada é mapeado diretamente para o nível elétrico do sinal de saída: o bit `1` mantém o pulso em nível lógico alto e o bit `0` mantém o pulso em nível lógico baixo, sem retorno ao zero entre bits consecutivos.

## Estrutura desta pasta

```
nrz_l/
├── src/                    Código-fonte VHDL do circuito
├── sim/                    Testbench para simulação
├── constraints/            Mapeamento dos pinos da FPGA (.xdc)
├── vivado_project/         Projeto Vivado pronto para abrir
├── docs/                   Tutoriais e documentação técnica
└── extras/                 Atividades opcionais (VGA)
```

## Arquivos de código

| Arquivo | Descrição |
|---------|-----------|
| `src/nrz_l.vhd` | Código-fonte do circuito principal. Recebe 16 bits pelos switches e gera o sinal modulado NRZ-L no LED. Utiliza o generic `CYCLES_PER_BIT` (padrão: 25.000.000 ciclos = 0,25 s por bit a 100 MHz) para controlar a duração de cada pulso. |
| `sim/tb_nrz_l.vhd` | Testbench para simulação comportamental. Aplica a sequência `1011001011010011` com `CYCLES_PER_BIT = 4` (período de 20 ns por bit) para verificação rápida no waveform. |
| `constraints/nrz_l.xdc` | Arquivo de constraints para a placa Basys3 rev B. Mapeia os 16 switches para `data_in`, o LED LD0 para `nrz_l_out`, BTNC para `enable` e BTNU para `rst`. Inclui mapeamento do conector VGA para o extra. |

## Documentação

- [Tutorial de simulação](./docs/tutorial_simulacao.pdf) — como simular no Vivado passo a passo
- [Tutorial de gravação na placa](./docs/tutorial_placa.pdf) — como sintetizar, gerar bitstream e gravar na FPGA
- [Documentação técnica](./docs/documentacao_projeto.pdf) — diagrama de blocos, descrição das portas e funcionamento

## Por onde começar

Para uma **simulação rápida** (apenas ver funcionando):

1. Abrir o Vivado e carregar `vivado_project/nrz_l.xpr`
2. Clicar em `Run Simulation` → `Run Behavioral Simulation`

Para **reproduzir o projeto do zero**, siga esta ordem:

1. **Entenda o circuito** lendo a [documentação técnica](./docs/documentacao_projeto.pdf)
2. **Simule no Vivado** seguindo o [tutorial de simulação](./docs/tutorial_simulacao.pdf)
3. **Grave na placa** seguindo o [tutorial de gravação](./docs/tutorial_placa.pdf)
4. (Opcional) Explore os [extras](./extras/) — saída VGA

## Extras (opcionais)

- ✅ [Saída VGA com cores pulsantes](./extras/vga/) — a tela exibe uma barra verde (nível alto) ou barra vermelha (nível baixo) conforme o sinal modulado, com fundo azul escuro. Implementado no módulo `vga_top.vhd` que instancia o `nrz_l` internamente.

## Próximo passo

Após concluir este projeto, siga para a [Modulação NRZ-I](../nrz_i/), que implementa a outra versão estudada no trabalho.
