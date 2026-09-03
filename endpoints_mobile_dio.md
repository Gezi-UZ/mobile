# Integração Mobile ↔ Backend (Gezi API via Dio)

Este documento foi elaborado especificamente para a equipa de Front-end (Flutter) para consumir os endpoints da **Gezi API (v1)**. Todos os endpoints já estão implementados no backend FastAPI.

A base URL (exemplo em desenvolvimento) será algo como: `http://10.0.2.2:8000/v1` (para Android Emulator) ou o respetivo URL de Stage/Produção.

## 1. Configuração do Dio & Interceptors (JWT)

Como o login é feito diretamente com o Supabase no Mobile, o backend Gezi atua como um *Resource Server* protegido. **Todos os pedidos (exceto rotas públicas, se existirem) exigem um JWT Access Token.**

> [!IMPORTANT]
> No vosso `Dio` cliente no Flutter, garantam que têm um interceptor que injeta sempre o `access_token` do Supabase no *header* `Authorization`.
> 
> ```dart
> dio.options.headers['Authorization'] = 'Bearer ${session.accessToken}';
> ```

---

## 2. Endpoints de Utilizadores (`/v1/users`)

Estes endpoints gerem o perfil do utilizador na nossa base de dados relacional.

### 2.1. Sincronizar Registo (Signup Sync)
**POST** `/users/`
> Deve ser chamado **imediatamente após o sucesso** de `supabase.auth.signUp()`. Serve para espelhar a conta na nossa Base de Dados para que ele possa ter contadores e faturas.

**Body (JSON):**
```json
{
  "telefone": "+258840000000",
  "nome": "João Silva",
  "papel": "cliente",
  "biometria_activa": false,
  "id": "uuid-do-supabase-aqui"
}
```

**Response (200 OK):**
Retorna o perfil recém-criado.

### 2.2. Obter Perfil
**GET** `/users/me`
> Obtém os dados do utilizador atualmente autenticado.

**Response (200 OK):**
```json
{
  "id": "uuid-do-supabase-aqui",
  "telefone": "+258840000000",
  "nome": "João Silva",
  "papel": "cliente",
  "biometria_activa": true,
  "created_at": "2026-09-02T12:00:00",
  "updated_at": null
}
```

### 2.3. Atualizar Perfil
**PUT** `/users/me`

**Body (JSON - Campos Opcionais):**
```json
{
  "nome": "João Silva Editado",
  "biometria_activa": true
}
```

---

## 3. Endpoints de Contadores (`/v1/meters`)

### 3.1. Listar Meus Contadores
**GET** `/meters/me`
> Retorna a lista de contadores (IoT) associados ao utilizador atual.

**Response (200 OK):**
```json
[
  {
    "id": "uuid-do-contador",
    "serial_number": "GEZI-00123",
    "label": "Casa Matola",
    "location": {
      "latitude": -25.9692,
      "longitude": 32.5732,
      "address": "Matola Rio"
    },
    "estado": "ACTIVO",
    "kwh_saldo": 45.2,
    "estado_rele": true,
    "ultima_recarga": "2026-09-01T14:30:00"
  }
]
```

### 3.2. Adicionar Novo Contador
**POST** `/meters/`

**Body (JSON):**
```json
{
  "serial_number": "GEZI-00124",
  "label": "Casa Cidade",
  "location": {
    "latitude": -25.123,
    "longitude": 32.456,
    "address": "Av. Julius Nyerere"
  }
}
```
*(Response retorna o objeto Contador criado).*

### 3.3. Detalhes do Contador
**GET** `/meters/{meter_id}`
> Retorna os detalhes de um contador específico. Substituir `{meter_id}` pelo UUID do contador.

### 3.4. Estado em Tempo Real (Dashboard Hardware)
**GET** `/meters/{meter_id}/status`
> Útil para ecrãs de "Live View", onde mostramos o saldo atual, o estado do relé (ligado/desligado) e a última sincronização.

**Response (200 OK):**
```json
{
  "estado": "ACTIVO",
  "kwh_saldo": 12.5,
  "estado_rele": true,
  "ultima_sincronizacao": "2026-09-02T14:30:00"
}
```

---

## 4. Endpoints de Recargas (`/v1/recharges`)

### 4.1. Iniciar Recarga (M-Pesa / Integração Automática)
**POST** `/recharges/initiate`
> Inicia o processo de compra de energia para um contador específico (vai disparar o flow de pagamento, ex: Prompt do M-Pesa).

**Body (JSON):**
```json
{
  "meter_id": "uuid-do-contador",
  "amount_mzn": 150.00
}
```

**Response (201 Created):**
```json
{
  "recharge_id": "uuid-da-recarga",
  "status": "PENDENTE_PAGAMENTO",
  "amount_mzn": 150.0,
  "estimated_kwh": 20.5,
  "breakdown": {
    "montante_total": 150.0,
    "val_energia": 115.0,
    "iva": 19.5,
    "divida_paga": 0.0,
    "tx_radio": 8.0,
    "tx_lixo": 7.5,
    "kwh_calculado": 20.5
  }
}
```
> [!TIP]
> A App deve usar o `recharge_id` devolvido para fazer *polling* (ou via WebSockets, se implementarmos) para saber quando o pagamento foi confirmado.

### 4.2. Verificar Estado da Recarga (Polling)
**GET** `/recharges/{recharge_id}/status`
> Usado após iniciar uma recarga. A app móvel deve chamar este endpoint de X em X segundos até o `status` mudar para `"CONCLUIDA"`.

**Response (200 OK):**
```json
{
  "recharge_id": "uuid-da-recarga",
  "status": "CONCLUIDA",
  "token": "1234-5678-9012-3456",
  "applied_at": "2026-09-02T14:35:00"
}
```

### 4.3. Inserir Código Manualmente (Falha de IoT ou Legacy)
**POST** `/recharges/manual-code`
> Se o utilizador comprou energia no banco e tem o talão, pode introduzir o código na App.

**Body (JSON):**
```json
{
  "meter_id": "uuid-do-contador",
  "recharge_code": "4321-8765-1098-7654"
}
```

**Response (200 OK):**
```json
{
  "recharge_id": "uuid-da-recarga-criada",
  "status": "CONCLUIDA",
  "credit_kwh": 40.0
}
```

### 4.4. Histórico de Recargas
**GET** `/recharges/history`
> Pode aceitar *query params* (ex: `?page=1&page_size=20`) se suportado.

**Response (200 OK):**
```json
{
  "recharges": [
    {
      "recharge_id": "uuid-aqui",
      "meter_id": "uuid-contador",
      "amount_mzn": 150.0,
      "credit_kwh": 20.5,
      "status": "CONCLUIDA",
      "created_at": "2026-09-02T10:00:00"
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total": 47
  }
}
```

### 4.5. Dashboard (Estatísticas de Consumo)
**GET** `/recharges/dashboard`
> Fornece os agregados para desenhar gráficos e *cards* de sumário. Pode aceitar `meter_id` ou `period` por query string.

**Response (200 OK):**
```json
{
  "total_spent_mzn": 1840.00,
  "total_kwh_purchased": 254.3,
  "average_consumption_kwh_day": 8.4,
  "recharge_count": 12
}
```

---

## 5. Endpoints Administrativos (Role: "admin")
Existem também endpoints sob o prefixo `/v1/admin/` (`/admin/users` e `/admin/meters`), mas a App Móvel normal do cliente não consumirá estas rotas (apenas dashboards web internos ou uma App de administração), pois irão ser bloqueadas por *Guards* de Role-Based Access Control (RBAC).
