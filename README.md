# Desafio Flutter

Este projeto faz parte de um desafio para praticar e demonstrar habilidades no desenvolvimento com Flutter. Ele inclui telas de login, cadastro de produtos, listagem de produtos e gerenciamento de usuários.

## 📌 Funcionalidades
- **Tela de Login**: Autenticação com validação de credenciais.
- **Gerenciamento de Usuários**: Cadastro, listagem e permissões configuráveis.
- **Cadastro de Produtos**: Formulário com validações e categorias.
- **Listagem de Produtos**: Tabela interativa com opções de edição e exclusão.
- **Gerenciamento de Estado**: Implementado com o **Provider**.

## 🛠 Tecnologias Utilizadas
- **Flutter (Dart)**: Framework para desenvolvimento multiplataforma.
- **Provider**: Gerenciamento de estado.
- **Intl**: Formatação de números e datas.
- **Dio**: Requisições HTTP.

## 📂 Estrutura de Pastas
- **lib/screens**: Contém as telas do aplicativo (ex.: Login, Cadastro de Produtos, Gerenciamento de Usuários).
- **lib/models**: Modelos de dados (ex.: `Product`, `User`).
- **lib/providers**: Gerenciamento de estado com `Provider` (ex.: `ProductProvider`, `UserProvider`).
- **lib/core**: Utilitários e configurações globais (ex.: `http_utils`, interceptores de API).
- **lib/api**: Integração com a API, incluindo serviços e endpoints.

## 🚀 Como Executar
1. Clone o repositório.
2. Instale as dependências:
   ```bash
   flutter pub get
3. Execute o projeto:
    ```bash
    flutter run
