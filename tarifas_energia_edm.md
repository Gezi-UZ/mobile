# Plano Detalhado de Tarifas de Energia Eléctrica (EDM)

Este documento apresenta a explicação detalhada sobre a estrutura tarifária da **Electricidade de Moçambique (EDM)**, incluindo o valor por kWh, taxas aplicáveis e o método exato de cálculo da quantidade de kWh obtida por determinado valor em Meticais (MT), com destaque para a primeira compra do mês no sistema de pré-pagamento (CREDELEC).

---

## 1. Tabela Tarifária por kWh (Baixa Tensão)

A cobrança varia consoante a modalidade de medição (**Pré-pagamento / CREDELEC** vs. **Pós-pago / Factura Mensal**) e a categoria do consumidor.

### A. Modalidade Pré-Pagamento (CREDELEC)
No sistema CREDELEC, o preço por kWh é fixo por categoria tarifária (não utiliza escalões progressivos):

| Categoria Tarifária | Preço por kWh (MT/kWh) | Condições / Observações |
| :--- | :---: | :--- |
| **Tarifa Social** | **0,97 MT** | Potência até 1,1 kVA, limite de 5 Amperes e consumo não superior a 125 kWh/mês |
| **Tarifa Doméstica** | **7,64 MT** | Residências familiares padrão |
| **Tarifa Agrícola** | **5,11 MT** | Actividades e bombagem agrícola |
| **Tarifa Geral** | **13,34 MT** | Comércio, serviços, escritórios e pequenas indústrias |

---

### B. Modalidade Pós-Pago (Factura Mensal com Escalões)
No sistema pós-pago, o valor do kWh varia por **escalão de consumo mensal**, sendo acrescido de uma **Taxa Fixa mensal de 233,37 MT**:

| Escalão de Consumo (kWh/mês) | Doméstica (MT/kWh) | Agrícola (MT/kWh) | Geral (MT/kWh) | Taxa Fixa Mensal |
| :--- | :---: | :---: | :---: | :---: |
| **De 0 a 300 kWh** | 6,00 MT | 3,69 MT | 9,32 MT | 233,37 MT |
| **De 301 a 500 kWh** | 8,49 MT | 5,26 MT | 13,31 MT | 233,37 MT |
| **Superior a 500 kWh** | 8,91 MT | 5,75 MT | 14,56 MT | 233,37 MT |

---

## 2. Grandes Consumidores e Outras Tensões

Para instalações de maior dimensão comercial ou industrial, aplicam-se tarifas com componentes de demanda/potência:

| Categoria de Consumidores | Preço de Energia (MT/kWh) | Potência (MT/kW) | Taxa Fixa (MT) |
| :--- | :---: | :---: | :---: |
| **Grandes Consumidores BT (GCBT)** | 5,74 MT | 441,12 MT | 683,29 MT |
| **Média Tensão (MT)** | 4,78 MT | 497,03 MT | 3.207,25 MT |
| **Média Tensão Agrícola (MTA)** | 2,72 MT | 313,29 MT | 3.207,25 MT |
| **Alta Tensão (AT)** | 4,70 MT | 600,10 MT | 3.207,25 MT |

---

## 3. Taxas Aplicadas e a Primeira Compra do Mês (CREDELEC)

Na **primeira recarga do mês civil** em contadores CREDELEC, o sistema realiza automaticamente as deduções fixas/fiscais antes de converter o saldo restante em energia (kWh):

1. **Taxa de Lixo Municipal (Taxa de Resíduos Sólidos / Limpeza Urbana):**
   * Cobrada pela EDM em representação do Conselho Municipal local.
   * O montante varia conforme o município e a categoria de consumo (ex.: nos municípios de Maputo e Matola, os valores situam-se geralmente entre 50 MT e 250 MT).
2. **Imposto sobre o Valor Acrescentado (IVA):**
   * Incide sobre as taxas ou serviços tributáveis de acordo com a legislação fiscal em vigor.

---

## 4. Fórmulas de Cálculo para Recargas CREDELEC

### A. Primeira Compra do Mês
$$\text{Valor Líquido para Energia} = \text{Valor do Recarregamento (MT)} - \text{Taxa de Lixo Municipal}$$

$$\text{Quantidade de kWh} = \frac{\text{Valor Líquido para Energia}}{\text{Tarifa por kWh (MT/kWh)}}$$

### B. Compras Subsequentes no Mesmo Mês (2ª compra em diante)
Como as taxas mensais já foram liquidadas na 1ª compra do mês:

$$\text{Quantidade de kWh} = \frac{\text{Valor do Recarregamento (MT)}}{\text{Tarifa por kWh (MT/kWh)}}$$

---

## 5. Exemplos Práticos de Cálculo

### Exemplo 1: Primeira compra do mês de 1.000 MT (CREDELEC Doméstico)
* **Preço por kWh:** 7,64 MT
* **Taxa de Lixo (assumida):** 100 MT
1. $\text{Valor para Energia} = 1.000\text{ MT} - 100\text{ MT} = 900\text{ MT}$
2. $\text{kWh Obtidos} = \frac{900\text{ MT}}{7,64\text{ MT/kWh}} \approx \mathbf{117,80\text{ kWh}}$

### Exemplo 2: Segunda compra no mesmo mês de 1.000 MT (CREDELEC Doméstico)
* Sem dedução de taxa de lixo (já liquidada):
1. $\text{Valor para Energia} = 1.000\text{ MT}$
2. $\text{kWh Obtidos} = \frac{1.000\text{ MT}}{7,64\text{ MT/kWh}} \approx \mathbf{130,89\text{ kWh}}$

### Exemplo 3: Compra na Tarifa Geral (Comércio) de 2.000 MT (CREDELEC)
* **Preço por kWh:** 13,34 MT
* **Taxa de Lixo (assumida):** 150 MT (1ª compra)
1. $\text{Valor para Energia} = 2.000\text{ MT} - 150\text{ MT} = 1.850\text{ MT}$
2. $\text{kWh Obtidos} = \frac{1.850\text{ MT}}{13,34\text{ MT/kWh}} \approx \mathbf{138,68\text{ kWh}}$
