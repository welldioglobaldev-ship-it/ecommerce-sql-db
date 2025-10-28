-- ===================================================================================
-- E-COMMERCE: SCRIPT COMPLETO DE CRIAÇÃO E POPULAÇÃO DO BANCO DE DADOS
-- -----------------------------------------------------------------------------------
-- CONTEÚDO: 
-- 1. DDL (Data Definition Language): CREATE DATABASE e CREATE TABLE.
-- 2. DML (Data Manipulation Language): INSERT INTO (Dados de Teste).
--
-- O script é seguro: DROP/CREATE é feito no início, e FOREIGN_KEY_CHECKS é desativado
-- temporariamente para garantir a limpeza (TRUNCATE) sem erros de dependência.
-- ===================================================================================

-- 1. DDL (CRIAÇÃO DO ESQUEMA)

DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- 1.1 Tabelas Principais (Pais)

-- Table: Clients (Clientes)
CREATE TABLE Clients (
    idClient INT NOT NULL AUTO_INCREMENT,
    Fname VARCHAR(10) NOT NULL,
    MiddIe_Initial CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Birth_Date DATE,
    CONSTRAINT pk_client PRIMARY KEY (idClient),
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);

-- Table: Product (Produto)
CREATE TABLE Product (
    idProduct INT NOT NULL AUTO_INCREMENT,
    Pname VARCHAR(30) NOT NULL,
    Category ENUM('Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    Description VARCHAR(255),
    Value DECIMAL(10, 2) NOT NULL,
    Rating DECIMAL(2, 1) DEFAULT 0.0,
    CONSTRAINT pk_product PRIMARY KEY (idProduct)
);

-- Table: Orders (Pedidos)
CREATE TABLE Orders (
    idOrder INT NOT NULL AUTO_INCREMENT,
    idOderClient INT NOT NULL,
    Order_Status ENUM('Cancelado', 'Confirmado', 'Em processamento', 'Enviado', 'Entregue') DEFAULT 'Em processamento',
    Description VARCHAR(255),
    Shipping_Cost DECIMAL(10, 2) DEFAULT 15.00,
    CONSTRAINT pk_orders PRIMARY KEY (idOrder),
    CONSTRAINT fk_orders_client FOREIGN KEY (idOderClient) REFERENCES Clients (idClient)
);

-- Table: Seller (Vendedor Terceiro - Marketplace)
CREATE TABLE Seller (
    idSeller INT NOT NULL AUTO_INCREMENT,
    Corporate_Name VARCHAR(255) NOT NULL,
    Abs_Name VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(11),
    Location VARCHAR(255),
    CONSTRAINT pk_seller PRIMARY KEY (idSeller),
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Table: Supplier (Fornecedor)
CREATE TABLE Supplier (
    idSupplier INT NOT NULL AUTO_INCREMENT,
    Corporate_Name VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    Contact CHAR(11) NOT NULL,
    CONSTRAINT pk_supplier PRIMARY KEY (idSupplier),
    CONSTRAINT unique_cnpj_supplier UNIQUE (CNPJ)
);

-- Table: ProductStorage (Local de Estoque/Armazém)
CREATE TABLE ProductStorage (
    idProdStorage INT NOT NULL AUTO_INCREMENT,
    Location VARCHAR(255) NOT NULL,
    CONSTRAINT pk_product_storage PRIMARY KEY (idProdStorage)
);

-- 1.2 Tabelas Filhas (Adicionais de Negócio)

-- Table: Payment (Pagamento)
CREATE TABLE Payment (
    idPayment INT NOT NULL AUTO_INCREMENT,
    idPayOrder INT NOT NULL,
    Payment_Type ENUM('Cartão', 'Boleto', 'Pix') NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Payment_Date DATETIME DEFAULT NOW(),
    CONSTRAINT pk_payment PRIMARY KEY (idPayment),
    CONSTRAINT fk_payment_order FOREIGN KEY (idPayOrder) REFERENCES Orders (idOrder)
);

-- Table: Delivery (Entrega e Rastreio)
CREATE TABLE Delivery (
    idDelivery INT NOT NULL AUTO_INCREMENT,
    idDelOrder INT NOT NULL,
    Delivery_Status ENUM('Pendente', 'Em separação', 'Enviado', 'Em rota', 'Entregue') DEFAULT 'Pendente',
    Tracking_Code VARCHAR(50) NOT NULL,
    CONSTRAINT pk_delivery PRIMARY KEY (idDelivery),
    CONSTRAINT fk_delivery_order FOREIGN KEY (idDelOrder) REFERENCES Orders (idOrder),
    CONSTRAINT unique_tracking_code UNIQUE (Tracking_Code)
);

-- 1.3 Tabelas Associativas (N:M)

-- Table: ProductOrder (Produtos por Pedido)
CREATE TABLE ProductOrder (
    idPoProduct INT NOT NULL,
    idPoOrder INT NOT NULL,
    Quantity INT DEFAULT 1,
    Product_Status ENUM('Disponível', 'Sem Estoque') DEFAULT 'Disponível',
    CONSTRAINT pk_product_order PRIMARY KEY (idPoProduct, idPoOrder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPoProduct) REFERENCES Product (idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPoOrder) REFERENCES Orders (idOrder)
);

-- Table: ProductSupplier (Produtos por Fornecedor)
CREATE TABLE ProductSupplier (
    idPsSupplier INT NOT NULL,
    idPsProduct INT NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT pk_product_supplier PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES Supplier (idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES Product (idProduct)
);

-- Table: ProductSeller (Produtos por Vendedor Terceiro - Marketplace)
CREATE TABLE ProductSeller (
    idPseller INT NOT NULL,
    idPproduct INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_product_seller PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller_seller FOREIGN KEY (idPseller) REFERENCES Seller (idSeller),
    CONSTRAINT fk_product_seller_product FOREIGN KEY (idPproduct) REFERENCES Product (idProduct)
);

-- Table: storagelocation (Localização do Estoque de Produtos)
CREATE TABLE storagelocation (
    idlproduct INT NOT NULL,
    idlstorage INT NOT NULL,
    Quantity INT NOT NULL,
    Location VARCHAR(255) NOT NULL,
    CONSTRAINT pk_storage_location PRIMARY KEY (idlproduct, idlstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idlproduct) REFERENCES Product (idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idlstorage) REFERENCES ProductStorage (idProdStorage)
);

-- ===================================================================================
-- 2. DML (INSERÇÃO DE DADOS DE TESTE)
-- ===================================================================================

-- Desativa a checagem de FKs para garantir que o TRUNCATE e a inserção funcionem
SET FOREIGN_KEY_CHECKS = 0;

-- 2.0 Limpeza de Dados (Necessária para rodar o script múltiplas vezes)
TRUNCATE TABLE ProductOrder;
TRUNCATE TABLE ProductSupplier;
TRUNCATE TABLE ProductSeller;
TRUNCATE TABLE storagelocation;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Delivery;
TRUNCATE TABLE Orders;
TRUNCATE TABLE Clients;
TRUNCATE TABLE Product;
TRUNCATE TABLE Seller;
TRUNCATE TABLE Supplier;
TRUNCATE TABLE ProductStorage;

-- 2.1 Dados de Clientes
INSERT INTO Clients (Fname, MiddIe_Initial, Lname, CPF, Address, Birth_Date) VALUES
('Ana', 'C', 'Silva', '11122233344', 'Rua A, 10 - Centro, São Paulo', '1990-05-15'),
('Bruno', 'S', 'Gomes', '22233344455', 'Av. B, 500 - Jd. América, Rio de Janeiro', '1985-11-20'),
('Carla', 'M', 'Souza', '33344455566', 'Rua C, 1200 - Bairro Feliz, Curitiba', '1998-03-01'),
('Daniel', 'A', 'Ramos', '44455566677', 'Estrada D, 20 - Zona Rural, Salvador', '2001-07-25'),
('Elena', 'P', 'Costa', '55566677788', 'Travessa E, 30 - Boa Viagem, Recife', '1976-09-10');

-- 2.2 Dados de Produtos
INSERT INTO Product (Pname, Category, Description, Value, Rating) VALUES
('Notebook Gamer X', 'Eletrônico', 'Processador i7, 16GB RAM, Placa RTX 3060', 4500.00, 4.8),
('Camiseta Casual', 'Vestuário', 'Algodão Pima, cor preta', 89.90, 4.5),
('LEGO Cidade', 'Brinquedos', 'Kit de construção de 800 peças', 350.50, 4.9),
('Café Gourmet', 'Alimentos', 'Grãos 100% Arábica, 500g', 35.00, 4.7),
('Mesa de Escritório', 'Móveis', 'Madeira maciça, 1.60m', 1200.00, 4.3),
('Mouse Sem Fio', 'Eletrônico', 'Ergonômico, 1600 DPI', 120.00, 4.6),
('Calça Jeans', 'Vestuário', 'Corte slim, azul escuro', 150.00, 4.4),
('Boneca Clássica', 'Brinquedos', 'Com acessórios e roupa extra', 150.00, 4.2),
('Cadeira de Jantar', 'Móveis', 'Conjunto com 4 cadeiras estofadas', 800.00, 4.1),
('Fones Bluetooth', 'Eletrônico', 'Cancelamento de ruído, 20h bateria', 450.00, 4.7);

-- 2.3 Dados de Vendedores (Terceiros)
INSERT INTO Seller (Corporate_Name, CNPJ, Location) VALUES
('Eletrônicos Master', '11111111000101', 'São Paulo'),
('Roupas Chiques', '22222222000102', 'Rio de Janeiro'),
('Móveis Rústicos', '33333333000103', 'Curitiba');

-- 2.4 Dados de Fornecedores
INSERT INTO Supplier (Corporate_Name, CNPJ, Contact) VALUES
('Tech Distribuidora', '44444444000104', '11987654321'),
('Alimentos Finos S/A', '55555555000105', '21912345678'),
('Logística Geral', '66666666000106', '41998765432');

-- 2.5 Dados de Estoque (Armazéns)
INSERT INTO ProductStorage (Location) VALUES
('Armazém Central SP'),
('Centro de Distribuição RJ'),
('Estoque Local PR');

-- 2.6 Dados de Pedidos
INSERT INTO Orders (idOderClient, Order_Status, Description, Shipping_Cost) VALUES
(1, 'Entregue', 'Pedido de aniversário', 25.00), -- Pedido 1 (Frete Alto)
(2, 'Em processamento', 'Compra recorrente', 15.00), -- Pedido 2
(3, 'Cancelado', 'Produto esgotado', 10.00),    -- Pedido 3
(4, 'Enviado', 'Entrega urgente', 30.00),       -- Pedido 4 (Frete Alto)
(1, 'Confirmado', 'Troca de produto', 15.00),  -- Pedido 5
(5, 'Entregue', 'Primeira compra', 15.00),     -- Pedido 6
(2, 'Entregue', 'Grande volume', 20.00),       -- Pedido 7 (Frete Alto)
(5, 'Confirmado', 'Itens pequenos', 12.00);    -- Pedido 8

-- 2.7 Dados de Pagamento (Ligado aos Pedidos)
-- Pagamento 1 (Pedido 1) = Valor Produtos (4500.00 + 89.90) + Frete (25.00) = 4614.90
INSERT INTO Payment (idPayOrder, Payment_Type, Amount) VALUES
(1, 'Cartão', 4614.90),
(2, 'Pix', 120.00 + 15.00), -- Valor Mouse + Frete
(4, 'Boleto', 450.00 + 30.00), -- Valor Fones + Frete
(6, 'Cartão', 1200.00 + 15.00), -- Valor Mesa + Frete
-- Pagamento 5 (Pedido 8) = Valor Produtos (150.00 + 35.00) + Frete (12.00) = 197.00
(8, 'Pix', 197.00);

-- 2.8 Dados de Entrega (Ligado aos Pedidos)
INSERT INTO Delivery (idDelOrder, Delivery_Status, Tracking_Code) VALUES
(1, 'Entregue', 'BR123456789SP'),
(2, 'Em separação', 'BR123456790RJ'),
(4, 'Em rota', 'BR123456792PR'),
(6, 'Entregue', 'BR123456794PE'),
(7, 'Entregue', 'BR123456795RJ');


-- 2.9 Dados Associativos (N:M)

-- ProductOrder (Quais produtos em quais pedidos)
INSERT INTO ProductOrder (idPoProduct, idPoOrder, Quantity) VALUES
(1, 1, 1), -- Notebook (Pedido 1)
(2, 1, 1), -- Camiseta (Pedido 1)
(6, 2, 1), -- Mouse (Pedido 2)
(7, 3, 2), -- Calça (Pedido 3 - Cancelado)
(10, 4, 1), -- Fones (Pedido 4)
(5, 5, 1), -- Mesa (Pedido 5)
(5, 6, 1), -- Mesa (Pedido 6)
(9, 7, 2), -- Cadeira (Pedido 7)
(8, 8, 1), -- Boneca (Pedido 8)
(4, 8, 1); -- Café (Pedido 8)

-- ProductSeller (Quais produtos são vendidos por quais Terceiros)
INSERT INTO ProductSeller (idPseller, idPproduct, Price) VALUES
(1, 1, 4600.00), -- Notebook (vendido por Eletrônicos Master)
(1, 6, 125.00),  -- Mouse (vendido por Eletrônicos Master)
(2, 2, 90.00),   -- Camiseta (vendido por Roupas Chiques)
(2, 7, 155.00),  -- Calça (vendido por Roupas Chiques)
(3, 5, 1300.00), -- Mesa (vendido por Móveis Rústicos)
(3, 9, 850.00);  -- Cadeira (vendido por Móveis Rústicos)

-- ProductSupplier (Quais produtos são fornecidos por quais Fornecedores)
INSERT INTO ProductSupplier (idPsSupplier, idPsProduct, Quantity) VALUES
(1, 1, 50), -- Tech Distribuidora fornece Notebook
(1, 6, 100),-- Tech Distribuidora fornece Mouse
(1, 10, 80),-- Tech Distribuidora fornece Fones
(2, 4, 200),-- Alimentos Finos fornece Café
(3, 5, 30), -- Logística Geral fornece Mesa
(3, 9, 40); -- Logística Geral fornece Cadeira

-- storagelocation (Onde estão os produtos em estoque)
INSERT INTO storagelocation (idlproduct, idlstorage, Quantity, Location) VALUES
(1, 1, 15, 'Corredor A'),  -- Notebook (Armazém SP)
(6, 1, 40, 'Corredor B'),  -- Mouse (Armazém SP)
(5, 3, 5, 'Prateleira F'),  -- Mesa (Estoque PR)
(9, 2, 20, 'Setor H'),      -- Cadeira (CD RJ)
(4, 1, 100, 'Câmara Fria'); -- Café (Armazém SP)


-- Reativa a checagem de FKs
SET FOREIGN_KEY_CHECKS = 1;
