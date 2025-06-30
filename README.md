# SQL Project

## Project Description

**Customer:** This is the entity where all customers are found, whether they are Buyers, Sellers, or Affiliates of the Site. The main attributes are email, name, city, country, address, date of birth, phone number, among others.

**Item:** This is the entity where the products published in our marketplace are located. The volume is very large because it includes all products that have been published at some point. Using the item status or cancellation date, you can detect active items in the marketplace.

**Item Category:** This is the entity where the description of each category with its respective path is found. Each item has a category associated with it.

**Order Info:** The order is the entity that reflects the transactions generated within the site (each purchase is an order). I chose to assume the shopping cart flow, as it exists in reality within the marketplace, therefore each order can have more than one item and in various quantities.

**Order Item:** Stores information about the order, such as which products were sold and their quantities.

## Requirements to be Met
1. List users with birthdays today whose number of sales made in January 2020 is greater than 1500.
2. For each month of 2020, list the top 5 users who sold the most (in R$) in the Cell Phones category. The analysis should include the month and year of analysis, seller's first and last name, number of sales made, quantity of products sold, and total amount transacted.
3. Create a new table with the price and status of items at the end of the day, ensuring it is reprocessable. In the Item table, only the last status informed by the PK should be maintained. (Can be solved through Stored Procedure).
4. Generate the DDL script for creating each of the tables represented in the ERD.

## Data Dictionary

### CUSTOMER
| Field Name               | Data Type     | Description                                           |
|--------------------------|---------------|-------------------------------------------------------|
| customer_id              | BIGINT        | Unique identifier for the customer (PK).             |
| hub_index_m10_customer_id| INT           | Internal index for the customer.                      |
| user_name                | VARCHAR(255)  | Customer name.                                        |
| user_email               | VARCHAR(255)  | Customer email address.                               |
| user_birthdate           | DATE          | Customer date of birth.                               |
| user_cellphone           | VARCHAR(20)   | Customer cell phone number.                           |
| user_city                | VARCHAR(255)  | Customer city.                                        |
| user_country             | VARCHAR(255)  | Customer country.                                     |
| user_role                | VARCHAR(255)  | Customer role (e.g., buyer, seller, affiliate, etc). |
| user_cluster             | VARCHAR(255)  | Customer segmentation information.                    |
| user_creation_date       | DATE          | Customer account creation date.                       |
| hub_transaction_date     | DATE          | Data transaction date for the customer record.       |
| user_status              | VARCHAR(255)  | Customer account status (e.g., active, inactive).    |

### ITEM
| Field Name                   | Data Type     | Description                                           |
|------------------------------|---------------|-------------------------------------------------------|
| item_id                      | BIGINT        | Unique identifier for the order item (PK).           |
| hub_transaction_date         | DATE          | Data transaction date for the item record.           |
| hub_index_m10_item_id       | INT           | Internal index for the item.                          |
| item_category_id             | BIGINT        | Unique identifier for the item category (FK).        |
| hub_index_m10_item_category_id | INT         | Internal index for the item category.                |
| user_producer_id             | BIGINT        | Unique identifier for the user who produced the item (FK). |
| item_name                    | VARCHAR(255)  | Item name.                                            |
| item_description             | VARCHAR(255)  | Item description.                                     |
| item_link                    | VARCHAR(255)  | Item link.                                            |
| item_currency_code           | VARCHAR(3)    | Currency code used for the item price.               |
| item_price                   | DECIMAL(10,2) | Item value.                                           |
| item_distribution_form       | VARCHAR(255)  | Item distribution form (digital, physical).          |
| item_status                  | VARCHAR(255)  | Item status (e.g., active, inactive, unavailable).   |
| item_creation_date           | DATE          | Item creation date.                                   |
| item_cancellation_date       | DATE          | Item cancellation date.                               |
| item_published_date          | DATE          | Item publication date.                                |

### ITEM CATEGORY
| Field Name                   | Data Type     | Description                                           |
|------------------------------|---------------|-------------------------------------------------------|
| item_category_id             | BIGINT        | Unique identifier for the item category (PK).        |
| category_description         | VARCHAR(255)  | Item category description.                            |
| hub_index_m10_item_category_id | INT         | Internal index for the item category.                |
| is_category_enable           | BOOLEAN       | Indicates if the category is active.                 |
| item_category_name           | VARCHAR(255)  | Item category name.                                   |

### ORDER INFO
| Field Name                 | Data Type     | Description                                                      |
|----------------------------|---------------|------------------------------------------------------------------|
| order_id                   | BIGINT        | Unique identifier for the order (PK).                           |
| hub_index_m10_customer_id  | INT           | Internal index for the customer in the order.                   |
| hub_index_m10_item_id      | INT           | Internal index for the item in the order.                       |
| hub_index_m10_order_id     | INT           | Internal index for the order.                                   |
| affiliation_id             | BIGINT        | Unique identifier for the affiliation associated with the order. |
| hub_transaction_date       | DATE          | Data transaction date for the order record.                     |
| order_currency_code_from   | VARCHAR(3)    | Currency code used for the original price.                      |
| order_currency_code_to     | VARCHAR(3)    | Currency code used for the final price.                         |
| order_customer_ip          | VARCHAR(255)  | Buyer's IP address at the time of order.                        |
| order_date                 | DATE          | Order request date.                                              |
| order_date_time            | DATETIME      | Order request date and time.                                     |
| order_origin               | VARCHAR(255)  | Order origin (e.g., social media, google, etc).                 |
| order_payment_type         | VARCHAR(255)  | Payment method used for the order.                              |
| order_release_date         | DATE          | Order/payment release date.                                      |
| order_release_datetime     | DATETIME      | Order/payment release date and time (including time).           |
| order_sale_type            | VARCHAR(255)  | Type of sale associated with the order (direct sale or by affiliation). |
| order_status               | VARCHAR(255)  | Order status (e.g., pending, shipped, canceled).                |
| order_value                | DECIMAL(10,2) | Total order value.                                               |
| payment_mode_description   | VARCHAR(255)  | Description of payment method used (installment, single payment). |
| user_affiliate_id          | BIGINT        | Unique identifier for the user affiliated with the order (FK).  |
| user_buyer_id              | BIGINT        | Foreign key that references the customer who placed the order (FK). |
| user_producer_id           | BIGINT        | Unique identifier for the user who produced the item (FK).      |

### ORDER ITEM
| Field Name           | Data Type     | Description                                          |
|----------------------|---------------|------------------------------------------------------|
| order_item_id        | BIGINT        | Unique identifier for the order item (PK).          |
| hub_transaction_date | DATE          | Data transaction date for the order record.         |
| item_id              | BIGINT        | Unique identifier for the item in the order (FK).   |
| order_id             | BIGINT        | Unique identifier for the order to which the order item belongs (FK). |
| order_item_value     | DECIMAL(10,2) | Total value (quantity * unit price).                |
| quantity             | INT           | Quantity of the item in the order.                  |
