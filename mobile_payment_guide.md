# Guia de Implementação: Pagamentos Mobile (Flutter)

Este guia detalha o fluxo de pagamento M-Pesa (E2Payments) do lado do cliente (Flutter).
O fluxo foi redesenhado para ser assíncrono, utilizando **STK Push** para o telemóvel do cliente e **Server-Sent Events (SSE)** para feedback em tempo real.

---

## O Fluxo (User Journey)

1. O utilizador escolhe o valor da recarga e o contador.
2. O utilizador pode opcionalmente introduzir um número de telemóvel para o pagamento (se não o fizer, usamos o do seu perfil).
3. O Flutter chama o backend para **iniciar a recarga**.
4. O backend comunica com o E2Payments e envia um **Pop-up (STK Push)** para o telemóvel indicado.
5. O Flutter entra num estado de "A aguardar pagamento" e conecta-se à **stream SSE**.
6. O utilizador insere o PIN do M-Pesa no seu telemóvel.
7. O E2Payments processa o pagamento e o backend notifica o Flutter via SSE (estado: `MQTT_SENT`).
8. O hardware responde e o backend notifica o Flutter (estado: `CONCLUIDA`).
9. O Flutter exibe o ecrã de sucesso.

---

## 1. Iniciar a Recarga e Pagamento

A primeira chamada é feita via `POST` normal (Dio) para criar a recarga e disparar o STK Push.

**Endpoint:** `POST /v1/recharges/initiate`

### Request (Dart)

Podes enviar o campo `phone` (opcional). O formato correto são 9 dígitos, sem código do país (ex: `848512345`).

```dart
final response = await dio.post('/v1/recharges/initiate', data: {
  'meter_id': 'uuid-do-contador',
  'amount_mzn': 150.00,
  // Se não enviares o phone, o backend usa o do perfil do utilizador
  'phone': '848512345', 
});
```

### Handling da Resposta

Se o `payment_status` for `PROCESSING`, significa que o pop-up foi enviado com sucesso para o telemóvel.

```dart
if (response.statusCode == 201) {
  final data = response.data['data'];
  final rechargeId = data['recharge_id'];
  final paymentStatus = data['payment_status'];
  
  if (paymentStatus == 'PROCESSING') {
    // 1. Mostrar ecrã/loading: "Aguardando confirmação no M-Pesa..."
    // 2. Ligar ao SSE stream para escutar o estado (ver Passo 2)
    startListeningToRecharge(rechargeId);
  } else if (paymentStatus == 'FAILED') {
    // Mostrar erro: "Falha ao enviar pop-up M-Pesa. Tente novamente."
  }
}
```

> [!TIP]
> Se o utilizador demorar a introduzir o PIN e der timeout (normalmente ~45 segundos no M-Pesa), ou se ele cancelar, a stream SSE ou não envia resposta ou envia estado de falha (se suportado pelo reconciliador). Sugere-se ter um botão "Tentar Novamente" no UI após uns 60 segundos.

---

## 2. Acompanhar em Tempo Real (SSE)

Para evitar polling e ter feedback instantâneo, deves ligar-te ao endpoint SSE.

**Endpoint:** `GET /v1/recharges/{recharge_id}/stream`

### Implementação Recomendada (Dart + Dio)

```dart
import 'dart:convert';
import 'package:dio/dio.dart';

Future<void> startListeningToRecharge(String rechargeId) async {
  try {
    final response = await dio.get(
      '/v1/recharges/$rechargeId/stream',
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        },
      ),
    );

    final stream = response.data.stream as Stream<List<int>>;

    await for (final chunk in stream) {
      final lines = utf8.decode(chunk).split('\n');
      
      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final jsonStr = line.substring(6);
          final eventData = jsonDecode(jsonStr);

          // Verifica se o servidor encerrou a stream
          if (eventData['event'] == 'stream_end') {
            print("Stream encerrada pelo servidor.");
            return;
          }

          // Tratar actualizações de estado
          if (eventData['event'] == 'status_update') {
            final status = eventData['data']['status'];
            
            if (status == 'MQTT_SENT') {
              // Pagamento recebido, comando enviado para o contador.
              // UI: "Pagamento confirmado. A ligar a energia..."
            } 
            else if (status == 'CONCLUIDA') {
              // Fluxo 100% completo, energia ligada.
              // UI: Mostrar ecrã de sucesso!
              final kwhApplied = eventData['data']['kwh'];
              print("Sucesso! $kwhApplied kWh adicionados.");
              return; 
            }
            else if (status == 'FAILED' || status == 'REFUNDED') {
              // Falha geral
              // UI: Mostrar ecrã de erro
              return;
            }
          }
        }
      }
    }
  } catch (e) {
    print("Erro na conexão SSE: $e");
    // Implementar fallback (ex: consultar /status via poll manual)
  }
}
```

> [!NOTE]
> O nosso backend implementa **polling duplo**. Isto significa que, enquanto a conexão SSE no Flutter estiver aberta, o backend verifica o estado do pagamento a cada 5 segundos de forma super eficiente. Assim que o cliente puser o PIN, o backend detecta, continua o processo IoT e dispara a notificação para a stream.

---

## 3. Fallback: Se o utilizador fechar a app

Se o utilizador iniciar a compra, fechar a app e colocar o PIN do M-Pesa, o backend continua a processar **automaticamente** via *background reconciliation* (corre a cada 30 segundos).

Quando o utilizador reabrir a app, basta consultares o estado atual da recarga (One-Shot):

**GET** `/v1/recharges/{recharge_id}/status`

```json
{
  "success": true,
  "data": {
    "recharge_id": "uuid",
    "status": "CONCLUIDA", // O pagamento entrou enquanto a app estava fechada!
    "token": "1234-5678-9012"
  }
}
```

### Resumo dos Estados (`status`) da Recarga
* `PENDING` / `PAYMENT_PROCESSING`: A aguardar PIN do M-Pesa.
* `CONFIRMED`: Pagamento recebido, a processar IoT.
* `MQTT_SENT`: Comando enviado para o contador, à espera de resposta de hardware.
* `CONCLUIDA`: Tudo pronto.
* `FAILED`: Pagamento ou fluxo falhou.
