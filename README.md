# 🚀 Delphi API (PDV)

Bem-vindo ao repositório do projeto **Delphi API**. Trata-se de uma aplicação backend em Delphi, projetada como uma API Web Standalone via Console para integração e fornecimento de dados para sistemas de Ponto de Venda (PDV).

## 🛠️ Tecnologias e Arquitetura

O projeto foi construído utilizando as seguintes tecnologias e frameworks:

* **Linguagem:** Delphi / Object Pascal
* **Servidor Web:** WebBroker com Indy (`IdHTTPWebBrokerBridge`) - Aplicação Standalone em Console.
* **Banco de Dados:** Microsoft SQL Server
* **Persistência de Dados:** ADO (ActiveX Data Objects)
* **Manipulação de Dados:** `System.JSON` para parsing e montagem das respostas e requisições JSON.

### Diferenciais Técnicos
* **Thread-Safety:** Gerenciamento seguro em ambiente multithread. O componente do WebBroker gerencia requisições de forma simultânea. Para garantir o funcionamento da persistência (ADO) sob essas condições, o código implementa inicialização local de ponteiros COM (`CoInitialize` / `CoUninitialize`) e instanciação do DataModule a cada nova requisição. Isso evita gargalos de conexão e _deadlocks_ em cenários de acessos concorrentes ao banco de dados.
* **Console Interativo:** A aplicação provê uma interface de console via prompt, a qual permite que o usuário gerencie ativamente o estado da API e a porta da conexão.

## 📂 Estrutura do Projeto

* `API.dpr`: Ponto de entrada da aplicação, responsável pela execução do console interativo e do loop de eventos.
* `uWebModule.pas`: Central de roteamento do servidor WebBroker. Intercepta as requisições HTTP e distribui para os endpoints responsáveis pela lógica de negócios (CRUD) de Produtos.
* `uDMConexao.pas`: _Data Module_ contendo a camada física e responsável pela conexão (`conSQLServer`) de acesso ao banco de dados SQL Server.
* `ServerConst1.pas`: Dicionário de strings e constantes consumidas para retorno das mensagens exibidas na tela do console.

## ⚙️ Pré-requisitos

* **RAD Studio / Delphi** compatível com a paleta nativa `System.JSON` e WebBroker.
* **Microsoft SQL Server** em funcionamento com a referida base de dados ativada.
* O componente `conSQLServer` (dentro de `uDMConexao.dfm`) deve possuir uma String de Conexão válida para o ambiente em que será testado.

## 🚀 Como Executar

1. Clone o repositório em sua máquina local.
2. Abra o arquivo do projeto (`API.dproj`) na IDE do Delphi.
3. Configure previamente as propriedades do banco de dados apontando o servidor/credenciais para acesso à sua instância.
4. Compile e execute o projeto (utilize `F9` ou Run).
5. O terminal do console será aberto exibindo um prompt. Você poderá utilizar os comandos interativos abaixo:
   * `start`: Inicia o servidor HTTP para começar a responder chamadas.
   * `stop`: Encerra o serviço HTTP.
   * `status`: Exibe status de execução, porta vinculada e a versão atual.
   * `setport <porta>`: Altera a porta TCP do servidor (porta padrão é `8080`).
   * `help`: Exibe a lista de comandos aceitos.
   * `exit`: Para o servidor (se necessário) e encerra o aplicativo.

## 📡 Endpoints e Recursos Disponíveis

A API está programada para disponibilizar um **CRUD** da entidade de **Produtos** (`PDV_Produtos`), respondendo sempre no formato `application/json`.

| Método | Recurso (Action) | Descrição | Parâmetros |
| :--- | :--- | :--- | :--- |
| `GET` | Produtos | Retorna uma lista com todos os produtos ou com informações de um produto específico. | `?id=X` (opcional, realiza um filtro via ID) |
| `POST` | Novo Produto | Insere um novo registro de produto na base. | Via Body: Payload JSON contendo (`codigo_barras`, `descricao`, `preco_venda`, `estoque`) |
| `PUT` | Atualizar Produto | Realiza o Update num produto já existente. | `?id=X` (obrigatório, identifica o item) + Body contendo Payload JSON |
| `DELETE`| Excluir Produto | Remove definitivamente um produto do sistema. | `?id=X` (obrigatório, para a exclusão) |

## 📦 Estrutura Esperada no Banco de Dados

Para uso ou reconstrução da API em novos ambientes, a tabela `PDV_Produtos` consumida requer os seguintes campos-chave e tipagens básicas:

* `id_produto` (Integer, Chave Primária)
* `codigo_barras` (String / Varchar)
* `descricao` (String / Varchar)
* `preco_venda` (Decimal / Float / Double)
* `estoque` (Decimal / Float / Double)

---
*Desenvolvido em Delphi.*
