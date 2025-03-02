# Desafio Flutter

Este projeto faz parte de um desafio para praticar e demonstrar habilidades no desenvolvimento com Flutter. Ele inclui telas de login, cadastro de produtos e listagem de produtos.

## 📌 Funcionalidades
- Tela de **Login** estilizada
- Cadastro de **produtos** com campos personalizados
- Listagem de produtos com **tabela interativa**
- Uso do **Provider** para gerenciamento de estado

## 🛠 Tecnologias Utilizadas
- **Flutter (Dart)**
- **Provider** (Gerenciamento de estado)
- **Intl** (Formatação de números e datas)

## 📜 Estrutura do Projeto
### 1. main.dart - Configuracao Principal
- Importa as bibliotecas necessarias:
  - `material.dart`: Interface do Flutter
  - `services.dart`: Manipulacao de entrada de dados
  - `provider.dart`: Gerenciamento de estado
  - `intl.dart`: Formatacao de numeros e moedas

### 2. MyApp - Configuracao do Tema e Provider
- `ChangeNotifierProvider`: Define um Provider para gerenciar o estado global dos produtos.
- `theme`: Configura o tema do aplicativo.
- `home: LoginScreen()`: Define a tela inicial como a tela de login.

### 3. LoginScreen - Tela de Login
- `TextEditingController`: Controla a entrada de texto do e-mail e senha.
- `bool _stayConnected = false;` Define se o usuario quer manter-se conectado.
- Ao clicar em "Entrar", navega para a tela de listagem de produtos.

### 4. ProductFormScreen - Tela de Cadastro de Produtos
- Campos de entrada do formulario:
  - Codigo do produto
  - Nome
  - Quantidade
  - Valor de Venda (formatado como moeda)
  - Categoria (dropdown com opcoes: Vestido, Calca, Camiseta)
- Dropdown para selecao de categoria.
- Salva os produtos no Provider e exibe uma mensagem de sucesso.

### 5. ProductListScreen - Tela de Listagem de Produtos
- Exibe a listagem dos produtos cadastrados.
- Icone no canto superior direito permite voltar para o login.
- Botao para cadastrar um novo produto.
- Exibe uma tabela de produtos cadastrados.
- Possui botoes de editar e excluir.

### 6. ProductProvider - Gerenciador de Estado
- Gerencia os produtos cadastrados.
- Metodo `addProduct` adiciona um novo produto.
- Metodo `deleteProduct` remove um produto pelo ID.

## Resumo das Funcionalidades
- Login funcional
- Cadastro de produtos com codigo, nome, categoria, quantidade e valor
- Listagem de produtos com edicao e exclusao
- Gerenciamento de estado com Provider
