# Walkthrough: Integração de Dados Reais & Fim dos Mocks (Gezi Mobile)

Este documento descreve todas as alterações efectuadas na aplicação Flutter do projecto **Gezi** para eliminar dados mockados e conectar os fluxos de contadores, recargas, compra para terceiros e estimativas de telemetria à API real e ao Supabase.

---

## 1. O que foi feito

### Fase 1: Fundação — Configuração e Entidades de Domínio
- **Configuração de Ambiente (`.env`)**:
  - `API_BASE_URL` configurado para `https://gezi.up.railway.app/v1`.
- **Entidade `Meter` (`meter.dart`)**:
  - Adicionados campos de localização (`latitude`, `longitude`, `address`), estado do relé (`relayState`), e datas de controlo (`lastRechargeAt`, `lastSyncAt`).
- **Modelo `MeterModel` (`meter_model.dart`)**:
  - Suporte completo a parsing flexível de campos do backend FastAPI e Supabase (`id`/`meter_id`, `label`/`alias`, `kwh_saldo`/`credit_kwh`, `estado_rele`, `location`, `ultima_recarga`, `ultima_sincronizacao`).

### Fase 2: State Management Real dos Contadores (`MeterBloc`)
- **Implementação do `MeterBloc` (`meter_bloc.dart`, `meter_event.dart`, `meter_state.dart`)**:
  - Criado o BLoC completo para gerir o ciclo de vida dos contadores.
  - Suporta carregamento da lista (`MeterListRequested`), definição de contador principal com optimistic update (`MeterSetPrimaryRequested`), validação de contadores por número de série (`MeterValidateRequested`) e actualizações em tempo real via Supabase Realtime (`MeterUpdatedRealtime`).
- **Novos Casos de Uso**:
  - [`ValidateMeterBySerial`](file:///home/wenzino/Developer/Projects/Mobile/Gezi/mobile/lib/features/meter/domain/usecases/validate_meter_by_serial.dart): valida se um número de série existe no sistema EDM/backend.
  - [`WatchUserMeters`](file:///home/wenzino/Developer/Projects/Mobile/Gezi/mobile/lib/features/meter/domain/usecases/watch_user_meters.dart): escuta alterações na tabela `contador` do Supabase em tempo real.
- **Injecção de Dependências (`injection_container.dart`)**:
  - Registados todos os use cases de Meter e registado o `MeterBloc` como `LazySingleton` partilhado entre a Home, Lista de Contadores e fluxo de Recarga.

### Fase 3: Eliminação de Mocks — Home e Lista de Contadores
- **`MeterListPage` (`meter_list_page.dart`)**:
  - Eliminado o array estático `mockMeters`.
  - Migrado para `BlocConsumer<MeterBloc, MeterState>` com estados de carregamento, erro com botão de repetição, e lista dinâmica com `RefreshIndicator`.
- **`HomeRemoteDataSourceImpl` (`home_remote_data_source.dart`)**:
  - Removidos stubs de saldo e histórico fictício.
  - Conectado ao `DioClient` para consultar `/meters/me` (saldo e estado do contador principal) e `/recharges/history` (últimas recargas reais).
- **`HomePage` (`home_page.dart`)**:
  - Removidas todas as referências ao `MeterListPage.mockMeters`.
  - Integrado com `MeterBloc` para resolução em tempo real do contador activo e principal.

### Fase 4: Fluxo de Recarga e Validação para Terceiros
- **Recarga para Terceiros com Validação em Tempo Real (`recharge_step_meter.dart`)**:
  - Ao introduzir os 11 dígitos do contador de destino, a aplicação valida automaticamente a existência do contador através de `ValidateMeterBySerial`.
  - Exibe indicador de carregamento ("A validar contador no sistema EDM..."), feedback visual de sucesso (✓ contador reconhecido) ou erro (✗ contador não encontrado), bloqueando o avanço para contadores inválidos.
- **Selecção Dinâmica de Contadores na Recarga (`recharge_step_select_meter.dart`)**:
  - Removida lista estática `_meters`. Conectado ao `MeterBloc` para listar os contadores reais da conta e pré-seleccionar o favorito.
- **Recarga por Código de 20 Dígitos (`recharge_by_code_page.dart` & `recharge_status_page.dart`)**:
  - Eliminado `_mockMeters`. A tela carrega os contadores do utilizador via `MeterBloc`.
  - Conectado o envio do código à API real: `RechargeStatusPage` dispara `ApplyCodeEvent(code, meterNumber)`, que invoca `POST /recharges/manual-code`.
- **Cálculo Tarifário Oficial EDM (`recharge_remote_data_source.dart` & `recharge_breakdown_model.dart`)**:
  - Implementada chamada a `/recharges/calculate` com fallback para as regras oficiais da EDM (7,64 MT/kWh, dedução de 100 MT de Taxa de Lixo na primeira compra do mês).

### Fase 5: Estimativa de Consumo e Detalhes do Contador
- **`MeterDetailPage` (`meter_detail_page.dart` & `meter_stats_row.dart`)**:
  - Adicionado cálculo automático de autonomia e ritmo de consumo:
    - Média diária de consumo (kWh/dia) calculada a partir do intervalo real entre as recargas.
    - Autonomia prevista (dias restantes de energia) com base no saldo actual dividido pelo ritmo diário.
    - Card visual "Estimativa de Autonomia" exibindo dias estimados e avisos de saldo baixo.

---

## 2. Diagnóstico e Verificação de Qualidade

Executada análise estática com o Dart Analyzer / MCP:
```
# Diagnostics for root file:///home/wenzino/Developer/Projects/Mobile/Gezi/mobile
No errors
```
- **0 erros**, **0 avisos**, **0 hints**.
- Total conformidade com as regras de Clean Architecture (`.agents/rules/flutter-to-clean-architecture.md`).

---

## 3. Guia de Teste Manual para o Utilizador

1. **Testar Listagem e Adição de Contadores**:
   - Abrir a aplicação e navegar até "Os meus contadores".
   - Confirmar que a lista reflecte os contadores registados na tabela `contador` do Supabase.
2. **Testar Compra para Terceiro**:
   - Tocar em "Recarregar energia" -> "Recarregar para alguém".
   - Digitar 11 dígitos e verificar se a validação identifica se o contador existe ou exibe erro se for inexistente.
3. **Testar Recarga com Código STS de 20 Dígitos**:
   - Ir a "Inserir código manual".
   - Seleccionar o contador de destino da lista real.
   - Colar ou digitar o código de 20 dígitos e tocar em "Aplicar recarga".
4. **Testar Estimativa de Consumo**:
   - Tocar no card do contador na Home para abrir o Detalhe.
   - Verificar as estatísticas de "Este mês", "Dia médio" e o card de "Estimativa de Autonomia".
