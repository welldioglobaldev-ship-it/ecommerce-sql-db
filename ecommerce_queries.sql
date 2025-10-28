-- =======================================================
-- CONSULTAS SQL PARA RESPONDER AO DESAFIO DE NEGÓCIO
-- Baseado no script 'ecommerce_setup_completo.sql'
-- =======================================================

-- PERGUNTA 1: Quantos pedidos foram feitos por cada cliente?
-- (Usa GROUP BY e COUNT)
SELECT 
    CONCAT(c.Fname, ' ', c.Lname) AS Nome_Cliente,
    COUNT(o.idOrder) AS Total_Pedidos
FROM Clients c
LEFT JOIN Orders o ON c.idClient = o.idOderClient
GROUP BY c.idClient, Nome_Cliente
ORDER BY Total_Pedidos DESC;

-- PERGUNTA 2: Algum vendedor (Seller) também é fornecedor (Supplier)?
-- (Usa JOIN entre Seller e Supplier na coluna CNPJ)
SELECT
    s.Corporate_Name AS Nome_Vendedor,
    s2.Corporate_Name AS Nome_Fornecedor,
    s.CNPJ
FROM Seller s
INNER JOIN Supplier s2 ON s.CNPJ = s2.CNPJ;
-- Resultado esperado: Nenhum, pois não inserimos CNPJs iguais no DML.

-- PERGUNTA 3: Relação de nomes dos fornecedores e nomes dos produtos fornecidos.
-- (Usa Múltiplos JOINs para ligar Fornecedor -> productSupplier -> Produto)
SELECT
    sup.Corporate_Name AS Nome_Fornecedor,
    p.idProduct,
    p.Category,
    ps.quantity AS Quantidade_Fornecida
FROM Supplier sup
JOIN productSupplier ps ON sup.idSupplier = ps.idPsSupplier
JOIN Product p ON ps.idPsProduct = p.idProduct
ORDER BY Nome_Fornecedor, p.Category;

-- PERGUNTA 4: Relação de produtos, fornecedores e estoques (locais).
-- (Usa Múltiplos JOINs: Produto -> productSupplier -> Supplier & Produto -> storagelocation -> ProductStorage)
SELECT
    p.idProduct,
    p.Category,
    sup.Corporate_Name AS Nome_Fornecedor,
    ps.quantity AS Qtde_Fornecida,
    sLoc.location AS Local_Estoque_Geral,
    psg.Quantity AS Qtde_Estoque_No_Local
FROM Product p
-- Informação do Fornecedor
LEFT JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
LEFT JOIN Supplier sup ON ps.idPsSupplier = sup.idSupplier
-- Informação do Estoque
LEFT JOIN storagelocation sloc ON p.idProduct = sloc.idlproduct
LEFT JOIN ProductStorage psg ON sloc.idlstorage = psg.idProdStorage
ORDER BY p.idProduct;

-- PERGUNTA 5 (Exemplo de HAVING): Encontrar Clientes que fizeram pedidos com valor de frete acima da média.
-- (Usa Subconsulta e HAVING)
SELECT
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    COUNT(o.idOrder) AS Total_Pedidos_Acima_Media_Frete,
    SUM(o.Shipping_Cost) AS Custo_Total_Frete
FROM Clients c
JOIN Orders o ON c.idClient = o.idOderClient
GROUP BY Cliente
HAVING SUM(o.Shipping_Cost) > (SELECT AVG(Shipping_Cost) FROM Orders)
ORDER BY Custo_Total_Frete DESC;
