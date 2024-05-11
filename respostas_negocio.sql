

-- Pergunta 1: Lista de usuários com aniversário hoje e mais de 1500 vendas em janeiro de 2020.

-- Pressupostos:
-- * Estou selecionando apenas vendas como produtores e não como afiliados.
-- * Apenas vendas concluídas, ou seja, data de liberação não nula e status diferente de 'Reembolso' e 'Chargeback'.

-- Selecionando usuários cujo aniversário é hoje
WITH BirthdayUsers AS (
  SELECT 
    c.customer_id,
    c.user_email,
    c.user_name
  FROM Customer c
  WHERE CAST(c.user_birthdate AS DATE) = CURDATE()
)

-- Contando as vendas dos aniversariantes de hoje realizadas em janeiro de 2020.
SELECT 
  bu.customer_id as user_id
  bu.user_email,
  bu.user_name,
  COUNT(*) AS total_sales
FROM BirthdayUsers bu
INNER JOIN Order_info o ON bu.customer_id = o.user_producer_id
WHERE YEAR(o.order_realease_date) = 2020
  AND MONTH(o.order_realease_date) = 1
  -- filtrando apenas vendas aprovadas
  AND o.order_status NOT IN ('Reembolso', 'Chargeback') 
GROUP BY 1,2,3
-- filtrando mais de 1500 vendas
HAVING COUNT(*) > 1500 
ORDER BY total_sales DESC;



-- Pergunta 2 
-- Para cada mês de 2020, são solicitados os 5 principais usuários que mais venderam (R$) na categoria Celulares. 
-- São obrigatórios o mês e ano da análise, nome e sobrenome do vendedor, quantidade de vendas realizadas, quantidade de produtos vendidos e valor total transacionado.

--Pressupostos:
-- * Mais venderam - Em termos de valor transacionado e não de volume
-- * Transacoes pagas, ou seja, daata de liberacao nao nula e status diferente de 'Reembolso' e Chargeback


-- Calcula as vendas mensais por usuário na categoria Celulares em 2020
WITH cte_monthly_sales AS (
    SELECT
        LEFT(o.order_release_date, 7) AS month_year, 
        o.user_producer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_products_sold,
        SUM(oi.order_item_value) AS total_sales_amount
    FROM Order_info o
    INNER JOIN Order_item oi ON o.order_id = oi.order_id
    INNER JOIN Item i ON oi.item_id = i.item_id
    INNER JOIN Item_category ic ON i.item_category_id = ic.item_category_id
    WHERE ic.item_category_name = 'Celulares'
    AND o.order_status NOT IN ('Reembolso', 'Chargeback') 
    AND LEFT(o.order_release_date, 4) = '2020'
    GROUP BY 1,2
),

-- Classifica os usuários por mês com base no valor total transacionado
cte_top5_users_monthly AS (
    SELECT
        month_year,
        user_producer_id,
        total_sales_amount,
        total_orders,
        total_products_sold
        ROW_NUMBER() OVER (PARTITION BY month_year ORDER BY total_sales_amount DESC) AS ranking
    FROM cte_monthly_sales
)

-- Seleciona os 5 principais usuários por mês
SELECT
    t.month_year,
    t.user_producer_id,
    c.user_name,
    t.total_sales_amount
    t.total_products_sold,
    t.total_orders
FROM cte_top5_users_monthly t
INNER JOIN customer c ON c.user_id = t.user_producer_id
WHERE ranking <= 5
ORDER BY  t.month_year, ranking;




-- Pergunta 3 
-- É solicitada uma nova tabela a ser preenchida com o preço e status dos Itens no final do dia. Lembre-se de que deve ser reprocessável. Vale ressaltar que na tabela Item teremos apenas o último status informado pelo PK definido. (Pode ser resolvido através de StoredProcedure)

-- Tabela ITEM_HIST_PRICE
CREATE TABLE ITEM_HIST_PRICE (
    item_id BIGINT,
    status_date DATE,
    item_price DECIMAL(10,2),
    item_status VARCHAR(255),
    PRIMARY KEY (item_id, status_date),
    FOREIGN KEY (item_id) REFERENCES ITEM(item_id)
);

-- Stored Procedure para atualizar ITEM_HIST_PRICE
DELIMITER //
CREATE PROCEDURE Update_Item_Hist_Price()
BEGIN
    -- Insere o preço e status atual de cada item no final do dia
    INSERT INTO ITEM_HIST_PRICE (item_id, status_date, item_price, item_status)
    SELECT 
        item_id, 
        CURDATE() AS status_date, 
        item_price, 
        item_status
    FROM 
        ITEM
    ON DUPLICATE KEY UPDATE
        item_price = VALUES(item_price),
        item_status = VALUES(item_status);
END //
DELIMITER ;

-- Chama a Stored Procedure para atualizar ITEM_HIST_PRICE
CALL Update_Item_Hist_Price();

