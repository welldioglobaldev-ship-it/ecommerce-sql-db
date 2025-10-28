-- ===================================================================================
-- E-COMMERCE: SCRIPT DE INSERÇÃO DE DADOS (DML)
-- -----------------------------------------------------------------------------------
-- Conteúdo: INSERT INTO para todas as tabelas.
--
-- Nota: O TRUNCATE TABLE é usado para limpar as tabelas antes de popular,
-- e o SET FOREIGN_KEY_CHECKS garante que a limpeza rode sem erros de dependência.
-- ===================================================================================

USE ecommerce;

-- Desativa a checagem de FKs para garantir que o TRUNCATE funcione sem erros de dependência
SET FOREIGN_KEY_CHECKS = 0;

-- 2.0 Limpeza de Dados (Ordem inversa das dependências não é crítica com FK_CHECKS=0, mas é boa prática)
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
-- Pedido 1: Produtos (4500.00*1 + 89.90*1) + Frete (25.00) = 4614.90
INSERT INTO Payment (idPayOrder, Payment_Type, Amount) VALUES
(1, 'Cartão', 4614.90),
(2, 'Pix', 120.00 + 15.00), -- Valor Mouse + Frete
(4, 'Boleto', 450.00 + 30.00), -- Valor Fones + Frete
(6, 'Cartão', 1200.00 + 15.00), -- Valor Mesa + Frete
-- Pedido 8: Produtos (150.00*1 + 35.00*1) + Frete (12.00) = 197.00
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
