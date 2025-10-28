Projeto de Modelagem e Queries SQL para E-commerce

Este projeto implementa a modelagem lógica e o script de banco de dados (DDL e DML) para um cenário de e-commerce, conforme proposto no desafio de banco de dados SQL. O objetivo foi criar um esquema relacional robusto e populá-lo com dados para realizar consultas complexas.

1. Escopo e Modelagem Lógica

O modelo de dados abrange as principais entidades de um sistema de e-commerce, incluindo Clientes (Pessoa Física), Produtos, Pedidos, Fornecedores e Vendedores Terceiros (Marketplace).

Refinamentos Aplicados:

O modelo foi refinado para incluir os requisitos de negócio solicitados:

Clientes (PJ e PF): A tabela Clients foi modelada para Pessoa Física (CPF) e estruturada para fácil expansão para Pessoa Jurídica (CNPJ) ou utilização de tabelas de herança, mantendo a regra de que uma conta não pode ser PJ e PF simultaneamente.

Pagamento: Implementado na tabela Payment, detalhando o tipo de pagamento (Cartão, Pix, Boleto) e o valor final (Amount).

Entrega: Implementado na tabela Delivery, que armazena o status logístico (Delivery_Status) e o código de rastreio (Tracking_Code).

2. Estrutura do Banco de Dados (DDL)

O arquivo principal para o setup do banco é o ecommerce_setup_completo.sql.

Principais Tabelas e Relacionamentos:

Tabela

Descrição

Relacionamento PrincipalProjeto de Modelagem e Queries SQL para E-commerce

Este projeto implementa a modelagem lógica e o script de banco de dados (DDL e DML) para um cenário de e-commerce, conforme proposto no desafio de banco de dados SQL. O objetivo foi criar um esquema relacional robusto e populá-lo com dados para realizar consultas complexas.

1. Escopo e Modelagem Lógica

O modelo de dados abrange as principais entidades de um sistema de e-commerce, incluindo Clientes (Pessoa Física), Produtos, Pedidos, Fornecedores e Vendedores Terceiros (Marketplace).

Refinamentos Aplicados:

O modelo foi refinado para incluir os requisitos de negócio solicitados:

Clientes (PJ e PF): A tabela Clients foi modelada para Pessoa Física (CPF) e estruturada para fácil expansão para Pessoa Jurídica (CNPJ) ou utilização de tabelas de herança, mantendo a regra de que uma conta não pode ser PJ e PF simultaneamente.

Pagamento: Implementado na tabela Payment, detalhando o tipo de pagamento (Cartão, Pix, Boleto) e o valor final (Amount).

Entrega: Implementado na tabela Delivery, que armazena o status logístico (Delivery_Status) e o código de rastreio (Tracking_Code).

2. Estrutura do Banco de Dados (DDL)

O arquivo principal para o setup do banco é o ecommerce_setup_completo.sql.

Principais Tabelas e Relacionamentos:

Tabela

Descrição

Relacionamento Principal

Clients

Informações dos clientes (PF).

1:N com Orders

Product

Catálogo de produtos.

N:M com Orders, Supplier, Seller, ProductStorage

Orders

Registro dos pedidos realizados.

1:1 com Payment e Delivery

Payment

Detalhes da transação financeira.

N:1 com Orders

Delivery

Detalhes logísticos e rastreio.

N:1 com Orders

Seller

Vendedores terceiros (Marketplace).

N:M com Product

Supplier

Fornecedores de produtos.

N:M com Product

ProductOrder

Tabela associativa: Quais produtos estão em qual pedido.

N:M entre Product e Orders

3. Scripts SQL no Projeto

O projeto é composto pelos seguintes arquivos que devem ser incluídos no repositório:

1. ecommerce_setup_completo.sql (DDL e DML)

Este script contém:

A criação completa do esquema relacional (CREATE TABLE).

A inserção de dados de teste (INSERT INTO) para todas as tabelas, permitindo a execução imediata das consultas.

2. queries_desafio.sql (Consultas)

Este arquivo demonstra a aplicação de cláusulas complexas do SQL. As consultas foram elaboradas para responder a perguntas de negócio e explorar as seguintes cláusulas: SELECT, WHERE, ORDER BY, JOIN, GROUP BY, e HAVING.

Exemplos de Consultas Inclusas:

Contagem de pedidos por cliente (GROUP BY, COUNT).

Verificação de vendedores que também são fornecedores (JOIN por CNPJ).

Relação entre fornecedores, produtos e localização no estoque (Múltiplos JOINs).

Identificação de clientes com custos de frete acima da média (HAVING com Subquery).

Status de rastreio de pedidos por cliente (JOIN com a tabela Delivery).

Instruções para Execução:

O arquivo ecommerce_setup_completo.sql deve ser executado em um ambiente MySQL para criar o banco de dados ecommerce e popular todas as tabelas. Após a execução, o arquivo queries_desafio.sql pode ser executado para visualizar os resultados.

Clients

Informações dos clientes (PF).

1:N com Orders

Product

Catálogo de produtos.

N:M com Orders, Supplier, Seller, ProductStorage

Orders

Registro dos pedidos realizados.

1:1 com Payment e Delivery

Payment

Detalhes da transação financeira.

N:1 com Orders

Delivery

Detalhes logísticos e rastreio.

N:1 com Orders

Seller

Vendedores terceiros (Marketplace).

N:M com Product

Supplier

Fornecedores de produtos.

N:M com Product

ProductOrder

Tabela associativa: Quais produtos estão em qual pedido.

N:M entre Product e Orders

3. Scripts SQL no Projeto

O projeto é composto pelos seguintes arquivos que devem ser incluídos no repositório:

1. ecommerce_setup_completo.sql (DDL e DML)

Este script contém:

A criação completa do esquema relacional (CREATE TABLE).

A inserção de dados de teste (INSERT INTO) para todas as tabelas, permitindo a execução imediata das consultas.

2. queries_desafio.sql (Consultas)

Este arquivo demonstra a aplicação de cláusulas complexas do SQL. As consultas foram elaboradas para responder a perguntas de negócio e explorar as seguintes cláusulas: SELECT, WHERE, ORDER BY, JOIN, GROUP BY, e HAVING.

Exemplos de Consultas Inclusas:

Contagem de pedidos por cliente (GROUP BY, COUNT).

Verificação de vendedores que também são fornecedores (JOIN por CNPJ).

Relação entre fornecedores, produtos e localização no estoque (Múltiplos JOINs).

Identificação de clientes com custos de frete acima da média (HAVING com Subquery).

Status de rastreio de pedidos por cliente (JOIN com a tabela Delivery).

Instruções para Execução:

O arquivo ecommerce_setup_completo.sql deve ser executado em um ambiente MySQL para criar o banco de dados ecommerce e popular todas as tabelas. Após a execução, o arquivo queries_desafio.sql pode ser executado para visualizar os resultados.
