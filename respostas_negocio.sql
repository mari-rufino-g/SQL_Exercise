-- Question 1: List of users with birthday today and more than 1500 sales in January 2020.

-- Assumptions:
-- * I am selecting only sales as producers and not as affiliates.
-- * Only completed sales, i.e., release date not null and status different from 'Refund' and 'Chargeback'.

-- Selecting users whose birthday is today
WITH BirthdayUsers AS (
  SELECT 
    c.customer_id,
    c.user_email,
    c.user_name
  FROM Customer c
  WHERE CAST(c.user_birthdate AS DATE) = CURDATE()
)

-- Counting the sales of today's birthday users made in January 2020.
SELECT 
  bu.customer_id as user_id,
  bu.user_email,
  bu.user_name,
  COUNT(*) AS total_sales
FROM BirthdayUsers bu
INNER JOIN Order_info o ON bu.customer_id = o.user_producer_id
WHERE YEAR(o.order_release_date) = 2020
  AND MONTH(o.order_release_date) = 1
  -- filtering only approved sales
  AND o.order_status NOT IN ('Refund', 'Chargeback') 
GROUP BY 1,2,3
-- filtering more than 1500 sales
HAVING COUNT(*) > 1500 
ORDER BY total_sales DESC;



-- Question 2 
-- For each month of 2020, the top 5 users who sold the most (R$) in the Mobile Phones category are requested. 
-- The month and year of analysis, seller's first and last name, number of sales made, quantity of products sold and total transaction value are mandatory.

-- Assumptions:
-- * Most sold - In terms of transaction value and not volume
-- * Paid transactions, i.e., release date not null and status different from 'Refund' and 'Chargeback'


-- Calculates monthly sales by user in the Mobile Phones category in 2020
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
    WHERE ic.item_category_name = 'Mobile Phones'
    AND o.order_status NOT IN ('Refund', 'Chargeback') 
    AND LEFT(o.order_release_date, 4) = '2020'
    GROUP BY 1,2
),

-- Ranks users by month based on total transaction value
cte_top5_users_monthly AS (
    SELECT
        month_year,
        user_producer_id,
        total_sales_amount,
        total_orders,
        total_products_sold,
        ROW_NUMBER() OVER (PARTITION BY month_year ORDER BY total_sales_amount DESC) AS ranking
    FROM cte_monthly_sales
)

-- Selects the top 5 users per month
SELECT
    t.month_year,
    t.user_producer_id,
    c.user_name,
    t.total_sales_amount,
    t.total_products_sold,
    t.total_orders
FROM cte_top5_users_monthly t
INNER JOIN customer c ON c.user_id = t.user_producer_id
WHERE ranking <= 5
ORDER BY t.month_year, ranking;




-- Question 3 
-- A new table is requested to be populated with the price and status of Items at the end of the day. Remember that it must be reprocessable. It's worth noting that in the Item table we will only have the last status informed by the defined PK. (Can be solved through StoredProcedure)

-- ITEM_HIST_PRICE Table
CREATE TABLE ITEM_HIST_PRICE (
    item_id BIGINT,
    status_date DATE,
    item_price DECIMAL(10,2),
    item_status VARCHAR(255),
    PRIMARY KEY (item_id, status_date),
    FOREIGN KEY (item_id) REFERENCES ITEM(item_id)
);

-- Stored Procedure to update ITEM_HIST_PRICE
DELIMITER //
CREATE PROCEDURE Update_Item_Hist_Price()
BEGIN
    -- Inserts the current price and status of each item at the end of the day
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

-- Calls the Stored Procedure to update ITEM_HIST_PRICE
CALL Update_Item_Hist_Price();
