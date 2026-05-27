# Modulação Digital em VHDL

Trabalho da disciplina de Comunicação de Dados - Sistemas Reconfiguráveis, ministrada pelo professor Vinícius Sebba Borges.
Semestre 2026/1.

## Integrantes

- (Nome do Integrante 1)
- (Nome do Integrante 2)

## Descrição

Este trabalho implementa, em VHDL, dois sistemas de modulação digital: **Unipolar NRZ-L** e **Unipolar NRZ-I**. O código foi simulado no Vivado Simulator e implementado na placa Basys3 (Artix-7 FPGA). Os 16 switches da placa representam a sequência de bits de entrada, e o LED LD0 apresenta o pulso modulado na saída. Um botão (BTNC) inicia a transmissão e outro (BTNU) realiza o reset.

Além da implementação obrigatória, ambos os projetos incluem uma atividade extra de saída VGA com cores pulsantes, em que a tela alterna entre barras coloridas conforme o nível do sinal modulado.

## Estrutura do repositório

```
modulacao_vhdl/
├── README.md                   ← Você está aqui
├── nrz_l/                      Projeto da modulação NRZ-L (auto-contido)
│   ├── src/                    Código-fonte VHDL do circuito
│   ├── sim/                    Testbench para simulação
│   ├── constraints/            Mapeamento dos pinos da FPGA (.xdc)
│   ├── vivado_project/         Projeto Vivado pronto para abrir
│   ├── docs/                   Tutoriais e documentação técnica
│   └── extras/                 Atividades opcionais (VGA)
├── nrz_i/                      Projeto da modulação NRZ-I (auto-contido)
│   ├── src/                    Código-fonte VHDL do circuito
│   ├── sim/                    Testbench para simulação
│   ├── constraints/            Mapeamento dos pinos da FPGA (.xdc)
│   ├── vivado_project/         Projeto Vivado pronto para abrir
│   ├── docs/                   Tutoriais e documentação técnica
│   └── extras/                 Atividades opcionais (VGA)
└── relatorio_final/            Relatório técnico consolidado e vídeo demo
```

Cada projeto possui sua própria pasta `docs/` com tutoriais e documentação técnica, e uma pasta `extras/` com a atividade opcional de saída VGA.

## Projetos

- [Modulação NRZ-L](./nrz_l/) — bit representado pelo nível do pulso
- [Modulação NRZ-I](./nrz_i/) — bit representado pela transição do pulso

## Relatório

- [Relatório técnico final](./relatorio_final/relatorio.pdf)
- [Vídeo de demonstração](./relatorio_final/video_demo.mp4)

## Ferramentas utilizadas

- **Vivado** 2023.1 (simulação, síntese, implementação e gravação)
- **Placa FPGA** Digilent Basys3 (Xilinx Artix-7 XC7A35T-1CPG236C)
- **Clock** da placa: 100 MHz

## Como começar

Recomendamos iniciar pelo projeto NRZ-L. Acesse a pasta [nrz_l/](./nrz_l/) e siga o README local.
