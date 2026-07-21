# Gezi — Documento de Requisitos (v1.0)

**Aplicativo Móvel Baseado em IoT para Modernização do Sistema CREDELEC**
Electricidade de Moçambique (EDM) — Recarga Remota e Infraestrutura de Medição Avançada

| | |
|---|---|
| **Responsável** | Dai Wen Xuan |
| **Instituição** | Universidade Zambeze — Faculdade de Ciências e Tecnologia |
| **Versão** | 1.0 |
| **Data** | Junho de 2026 |

---

## 1. Propósito do Sistema

O Gezi visa modernizar e digitalizar a recarga de energia eléctrica pré-paga da EDM, eliminando a dependência de proximidade física ao terminal de recarga. A plataforma integra:

- **App móvel** (Flutter) para utilizadores residenciais
- **Backend** em FastAPI, com arquitectura Event-Driven
- **Broker MQTT** para comunicação segura com dispositivos IoT (ESP32)
- **M-Pesa** como infraestrutura de pagamento móvel existente em Moçambique

Tudo num único fluxo de recarga rastreável, seguro e auditável.

## 2. Minimundo e Problema de Negócio

O sistema CREDELEC actual só permite recargas dentro de um raio de proximidade física ao terminal. Isso gera três desafios centrais:

- **Viagens/ausências prolongadas** — dependência de terceiros (ex.: vizinhos) para recarregar
- **Emergências** — em desastres naturais (comuns na região da Beira), a impossibilidade de recarga remota agrava a vulnerabilidade das famílias
- **Populações rurais** — a dependência de terminais físicos reforça desigualdades socioeconómicas

### Fluxo principal proposto

1. Utilizador autentica-se via OTP (SMS) e/ou biometria
2. Selecciona o contador e escolhe entre comprar recarga na plataforma ou inserir código obtido por outro canal
3. Sistema processa a recarga e publica comando MQTT seguro para o ESP32
4. ESP32 recebe o comando, valida token HMAC, aplica o crédito localmente, actua o relay (se necessário) e actualiza o LCD
5. App móvel actualiza saldo em tempo real e envia notificação push

### Actores

| Actor | Descrição |
|---|---|
| Utilizador/Consumidor | Acesso via app móvel Flutter |
| Administrador EDM | Gestão de contadores, tarifas e auditoria via painel web |
| Dispositivo IoT (ESP32) | Terminal físico emulado em sandbox, firmware MicroPython |

## 3. Requisitos Funcionais (RF)

| ID | Descrição | Prioridade | Depende de |
|---|---|---|---|
| RF01 | Registo, edição e consulta de contadores CREDELEC (nº série, estado) | Alta | - |
| RF02 | Autenticação via OTP (SMS) e, opcionalmente, biometria local | Alta | - |
| RF03 | Recarga remota do contador a partir de qualquer localização | Alta | RF01, RF02 |
| RF04 | Integração de gateway de pagamento local (M-Pesa) in-app | Alta | RF03 |
| RF05 | Envio de comando MQTT seguro (`APPLY_CREDITS`) ao ESP32 | Alta | RF03, RF04 |
| RF06 | Histórico completo de recargas e consumo (kWh) em tempo real | Alta | RF01 |
| RF07 | Alertas automáticos (push/SMS) quando saldo atinge limiar configurável | Alta | RF06 |
| RF08 | Estado do contador em tempo real (Online/Offline, saldo, última recarga) via Supabase Realtime | Alta | RF01, RF06 |
| RF09 | Perfis de acesso distintos: Utilizador e Administrador EDM | Alta | - |
| RF10 | Painel administrativo (contadores, transacções, alertas, métricas) | Alta | RF09 |
| RF11 | Registo auditável de cada comando IoT (timestamp, estado, tentativas, resultado) | Alta | RF05 |
| RF12 | Fallback manual: token numérico via teclado decimal, sem internet | Média | RF05 |
| RF13 | Upload/visualização de documentos da conta (comprovativos, relatórios) | Média | RF02 |
| RF14 | Dashboard de estatísticas de consumo, gasto total e histórico com filtragem | Média | RF06 |
| RF15 | Exportação do histórico de consumo/transacções em PDF | Média | RF06 |
| RF16 | Introdução manual de código de recarga adquirido em canal externo, com validação | Alta | RF01, RF02 |

## 4. Regras de Negócio (RN)

| ID | Descrição | Prioridade | Depende de |
|---|---|---|---|
| RN01 | Cada crédito requer código de recarga válido e não usado; sem reutilização | Alta | - |
| RN02 | Comando só é enviado ao ESP32 após validação do código ou confirmação de pagamento | Alta | RN01 |
| RN03 | Registo de transacção financeira é imutável após confirmação | Alta | - |
| RN04 | Acesso exige sessão JWT válida; sessões expiradas exigem nova OTP | Alta | - |
| RN05 | Cada ESP32 autenticado por certificado digital único no broker MQTT | Alta | - |
| RN06 | Retry de comandos MQTT: máx. 3 tentativas, intervalo exponencial; após 3 falhas → FAILED + reembolso | Alta | RN02 |
| RN07 | Saldo armazenado localmente no ESP32 (operação offline); servidor é fonte de verdade para auditoria | Alta | - |
| RN08 | Taxas do gateway M-Pesa são responsabilidade da EDM/concessionário, não repassadas ao utilizador | Alta | - |
| RN09 | Acesso de cada perfil limitado aos dados/funcionalidades da sua função | Alta | - |
| RN10 | Cada código CREDELEC só pode ser aplicado uma vez; registo de códigos usados | Alta | RF05, RF16 |

## 5. Requisitos Não Funcionais (RNF)

| ID | Descrição | Categoria | Escopo | Prioridade | Depende de |
|---|---|---|---|---|---|
| RNF01 | Dados clínicos e financeiros com TLS 1.3 (HTTPS/MQTT) e encriptação em repouso (Supabase) | Segurança | Sistema | Alta | - |
| RNF02 | App compatível com Android 9+ e iOS 14+, em Flutter | Portabilidade | Sistema | Alta | - |
| RNF03 | Sincronização app↔servidor em tempo real, latência máx. 3s | Eficiência | Funcionalidade | Alta | RF08 |
| RNF04 | Suporte a até 500 utilizadores simultâneos, resposta API < 2s | Eficiência | Sistema | Alta | - |
| RNF05 | Backend em Clean Architecture, módulos por domínio (meter, recharge, payment, iot) | Manutenibilidade | Sistema | Alta | - |
| RNF06 | Integração com API oficial M-Pesa (OAuth + STK Push, Vodacom Moçambique) | Interoperabilidade | Funcionalidade | Alta | RF04 |
| RNF07 | Qualquer funcionalidade principal acessível em no máx. 3 interacções | Usabilidade | Sistema | Média | - |
| RNF08 | MQTT com QoS 1 para comandos críticos (`APPLY_CREDITS`, `CUT_SUPPLY`, `RESTORE_SUPPLY`) e QoS 0 para telemetria | Fiabilidade | Sistema | Alta | RF05 |

---

## 6. Resumo Quantitativo

- **16** Requisitos Funcionais (RF)
- **10** Regras de Negócio (RN)
- **8** Requisitos Não Funcionais (RNF)

---

*Baseado em: Gezi — Documento de Requisitos v1.0, Dai Wen Xuan, Universidade Zambeze, Junho de 2026.*
