# Instacar API

Bem-vindo ao repositório da **Instacar API**. Este projeto é responsável por fornecer a API para o aplicativo móvel Instacar, permitindo funcionalidades como gerenciamento de usuários, veículos e reservas.

## Funcionalidades

- Cadastro e autenticação de usuários.
- Gerenciamento de veículos disponíveis.
- Criação, edição e cancelamento de reservas.
- Integração com serviços externos (se aplicável).

## Tecnologias Utilizadas

- **Node.js**: Ambiente de execução JavaScript.
- **Express**: Framework para construção de APIs.
- **Postgresql**: Banco de dados NoSQL.
- **JWT**: Autenticação baseada em tokens.
- **Docker**: Contêineres para ambiente de desenvolvimento.

## Requisitos

- Node.js v16+.
- Postgresql instalado ou acesso a um cluster.
- Docker (opcional, para execução em contêineres).

## Instalação

1. Clone o repositório:
    ```bash
    git clone https://github.com/seu-usuario/instacar-api.git
    cd instacar-api
    ```

2. Instale as dependências:
    ```bash
    npm install
    ```

3. Configure as variáveis de ambiente:
    - Crie um arquivo `.env` baseado no `.env.example`.

4. Inicie o servidor:
    ```bash
    npm start
    ```

## Endpoints Principais

- **`POST /auth/register`**: Cadastro de novos usuários.
- **`POST /auth/login`**: Autenticação de usuários.
- **`GET /user`**: Informações do usuário