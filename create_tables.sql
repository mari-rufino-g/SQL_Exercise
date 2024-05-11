-- Gere o script DDL para a criação de cada uma das tabelas representadas no DER

-- Tabela ORDER_INFO
CREATE TABLE ORDER_INFO (
    order_id BIGINT PRIMARY KEY, 
    hub_index_m10_customer_id INT,
    hub_index_m10_item_id INT,
    hub_index_m10_order_id INT,
    affiliation_id BIGINT,
    hub_transaction_date DATE,
    order_currency_code_from VARCHAR(3),
    order_currency_code_to VARCHAR(3),
    order_customer_ip VARCHAR(255),
    order_date DATE,
    order_date_time DATETIME,
    order_origin VARCHAR(255),
    order_payment_type VARCHAR(255),
    order_release_date DATE,
    order_release_datetime DATETIME,
    order_sale_type VARCHAR(255),
    order_status VARCHAR(255),
    order_value DECIMAL(10,2),
    payment_mode_description VARCHAR(255),
    user_affiliate_id BIGINT,
    user_buyer_id BIGINT,
    user_producer_id BIGINT,
    FOREIGN KEY (user_affiliate_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (user_buyer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (user_producer_id) REFERENCES CUSTOMER(customer_id)
);

-- Tabela ORDER_ITEM
CREATE TABLE ORDER_ITEM (
    order_item_id BIGINT PRIMARY KEY,
    hub_transaction_date DATE,
    item_id BIGINT,
    order_id BIGINT,
    order_item_value DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (item_id) REFERENCES ITEM(item_id),
    FOREIGN KEY (order_id) REFERENCES ORDER_INFO(order_id)
);

-- Tabela ITEM_CATEGORY
CREATE TABLE ITEM_CATEGORY (
    item_category_id BIGINT PRIMARY KEY,
    category_description VARCHAR(255),
    hub_index_m10_item_category_id INT,
    is_category_enable BOOLEAN,
    item_category_name VARCHAR(255)
);

-- Tabela ITEM
CREATE TABLE ITEM (
    item_id BIGINT PRIMARY KEY,
    hub_transaction_date DATE,
    hub_index_m10_item_id INT,
    item_category_id BIGINT,
    hub_index_m10_item_category_id INT,
    user_producer_id BIGINT,
    item_name VARCHAR(255),
    item_description VARCHAR(255),
    item_link VARCHAR(255),
    item_currency_code VARCHAR(3),
    item_price DECIMAL(10,2),
    item_distribution_form VARCHAR(255),
    item_status VARCHAR(255),
    item_creation_date DATE,
    item_cancellation_date DATE,
    item_published_date DATE,
    FOREIGN KEY (item_category_id) REFERENCES ITEM_CATEGORY(item_category_id),
    FOREIGN KEY (user_producer_id) REFERENCES CUSTOMER(customer_id)
);

-- Tabela CUSTOMER
CREATE TABLE CUSTOMER (
    customer_id BIGINT PRIMARY KEY,
    hub_index_m10_customer_id INT,
    user_name VARCHAR(255),
    user_email VARCHAR(255),
    user_birthdate DATE,
    user_cellphone VARCHAR(20),
    user_city VARCHAR(255),
    user_country VARCHAR(255),
    user_role VARCHAR(255),
    user_cluster VARCHAR(255),
    user_creation_date DATE,
    hub_transaction_date DATE,
    user_status VARCHAR(255)
);
