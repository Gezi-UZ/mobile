# Arquitetura do Banco de Dados e Fluxo de Autenticação

Este documento explica como as tabelas foram criadas no banco de dados do backend, com foco especial na gestão de utilizadores e no fluxo de autenticação com o Supabase.

## 1. Criação das Tabelas (Modelos e Alembic)

Baseando-nos no Diagrama Entidade-Relacionamento (DER), construímos **Modelos SQLAlchemy** (Object-Relational Mapping) no backend (em `app/modules/*/domain/entities`). Estes modelos funcionam como a representação em código das tabelas do banco de dados (ex: `Contador`, `Recarga`, `Alerta`, `DispositivoIoT`, etc.).

Para criar efetivamente estas tabelas no PostgreSQL, utilizamos o **Alembic**, uma ferramenta de migrações para SQLAlchemy:
1. O Alembic leu todos os modelos através do ficheiro `app/core/base.py`.
2. Analisou a diferença entre os modelos de código e o estado vazio do banco de dados para gerar um **script de migração** (o ficheiro `.py` na pasta `alembic/versions`).
3. Quando executamos `alembic upgrade head`, este script envia os comandos SQL `CREATE TABLE` para o banco de dados.

## 2. A Tabela `users` (Supabase) vs Tabela `utilizadores` (Backend Gezi)

Uma das tabelas mais importantes é a de gestão de utilizadores. Na nossa arquitetura, os dados do utilizador estão divididos em dois sítios:

* **`auth.users` (Supabase Auth)**: Tabela interna gerida exclusivamente pelo Supabase. Guarda as credenciais de acesso (email, senha/PIN criptografado), tokens de sessão e estado de verificação.
* **`utilizadores` (Schema Public do Backend)**: A nossa tabela local. Contém os dados de negócio específicos do sistema Gezi (telefone, nome, papel do utilizador, biometria ativa, e os relacionamentos com contadores e pagamentos).

### O Relacionamento
Para ligar os dois mundos, a tabela `utilizadores` no backend tem a sua chave primária (`id`) configurada como uma **Foreign Key** que aponta diretamente para o `id` da tabela `auth.users` do Supabase.

### Fluxo de Registo (Signup)
Como a aplicação móvel comunica *diretamente* com o Supabase para gerir a autenticação, o fluxo de criação de conta funciona da seguinte forma:

1. **Na App**: O utilizador preenche os dados (Email, PIN, Nome). A app chama o SDK do Supabase (`supabase.auth.signUp`), passando o Nome dentro dos metadados (`user_metadata`).
2. **No Supabase**: Uma nova linha é inserida na tabela `auth.users`. O Supabase gere o hashing do PIN e emite o token de sessão.
3. **No Backend (Sincronização)**: Após o registo no `auth.users`, **é obrigatório** que uma linha correspondente seja inserida na tabela `utilizadores` do nosso backend para que o utilizador possa ter contadores e pagamentos.
   > [!NOTE]
   > **Como é feita esta sincronização?** Geralmente, isto é feito de duas formas:
   > - **Database Webhooks / Triggers (Recomendado)**: Configuramos um *Trigger* SQL diretamente no Supabase que, sempre que um novo utilizador é inserido em `auth.users`, insere automaticamente uma linha na tabela pública `utilizadores`, copiando o nome dos metadados.
   > - **Chamada da API**: A app, logo após receber sucesso do `signUp`, faz um POST para o backend Gezi (`/users`) enviando os dados restantes para criar o perfil.

## 3. Autenticação e o JWT (JSON Web Token)

Como visto na camada de dados da aplicação móvel (`AuthRemoteDataSource`), a App faz o login comunicando-se **diretamente com o Supabase**, sem passar pelo nosso backend em Python. 

Isto resulta num detalhe arquitetural importantíssimo: **A app obtém diretamente o JWT (Token de Sessão) emitido pelo Supabase.**

### Comunicação com o Backend (Os Guards)
O nosso backend FastAPI atua como um *Resource Server*. Não é ele que cria a sessão, mas é ele que tem de proteger os dados (como listar contadores ou iniciar recargas). 

Para que a App móvel possa consumir os endpoints do backend (ex: `GET /meters`):
1. A app móvel anexa o JWT do Supabase no cabeçalho das requisições HTTP (`Authorization: Bearer <token>`).
2. O Backend recebe o pedido e os seus **Guards / Dependencies** (ex: `ValidateTokenUseCase` ou `SupabaseJWTProvider`) extraem este token.
3. O Backend valida criptograficamente o JWT verificando se foi assinado pelo Supabase (usando a `JWT_SECRET_KEY` ou verificando as chaves JWKS do Supabase).
4. Se for válido, o backend extrai o `sub` (que é o `id` do utilizador), procura na tabela `utilizadores`, e permite a execução da rota de forma segura.

> [!IMPORTANT]
> É por isto que na aplicação móvel, no repositório de rede ou cliente HTTP (como o Dio ou HTTP package), **devemos configurar um Interceptor** que injete sempre o `AccessToken` do Supabase em todos os pedidos feitos para a API do backend Gezi.
