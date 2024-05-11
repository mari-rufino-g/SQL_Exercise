# Projeto de SQL

## Descrição do Projeto

**Customer:** É a entidade onde se encontram todos os clientes, sejam eles Compradores, Vendedores ou Afiliados do Site. Os principais atributos são email, nome, cidade, país, endereço, data de nascimento, telefone, entre outros.

**Item:** É a entidade onde estão localizados os produtos publicados em nosso marketplace. O volume é muito grande porque estão incluídos todos os produtos que foram publicados em algum momento. Usando o status do item ou a data de cancelamento, você pode detectar os itens ativos no marketplace.

**Item Category:** É a entidade onde se encontra a descrição de cada categoria com seu respectivo caminho. Cada item possui uma categoria associada a ele.

**Order Info:** O pedido é a entidade que reflete as transações geradas dentro do site (cada compra é um pedido). Optei por assumir o fluxo de carrinho de compras, tal como existe na realidade dentro do marketplace, portanto cada pedido pode ter mais de um item e em diversas quantidades.

**Order item:** Armazena as informações sobre o pedido, tais como quais produtos foram vendidos e suas quantidades.

## Necessidades a serem atendidas
1. Listar usuários com aniversário de hoje cujo número de vendas realizadas em janeiro de 2020 seja superior a 1500.
2. Para cada mês de 2020, listar os 5 principais usuários que mais venderam (em R$) na categoria Celulares. A análise deve incluir o mês e ano da análise, nome e sobrenome do vendedor, quantidade de vendas realizadas, quantidade de produtos vendidos e valor total transacionado.
3. Criar uma nova tabela com o preço e status dos itens no final do dia, garantindo que seja reprocessável. Na tabela Item, apenas o último status informado pelo PK deve ser mantido. (Pode ser resolvido através de Stored Procedure).
4. Gerar o script DDL para a criação de cada uma das tabelas representadas no DER.

## Dicionário de Dados

### CUSTOMER
| Nome do Campo            | Tipo de Dados | Descrição                                             |
|--------------------------|---------------|-------------------------------------------------------|
| customer_id              | BIGINT        | Identificador único para o cliente (PK).              |
| hub_index_m10_customer_id| INT           | Índice interno para o cliente.                        |
| user_name                | VARCHAR(255)  | Nome do cliente.                                      |
| user_email               | VARCHAR(255)  | Endereço de e-mail do cliente.                        |
| user_birthdate           | DATE          | Data de nascimento do cliente.                        |
| user_cellphone           | VARCHAR(20)   | Número de celular do cliente.                         |
| user_city                | VARCHAR(255)  | Cidade do cliente.                                    |
| user_country             | VARCHAR(255)  | País do cliente.                                      |
| user_role                | VARCHAR(255)  | Função do cliente (por exemplo, comprador, vendedor, afiliado, etc). |
| user_cluster             | VARCHAR(255)  | Informação de segmentação do cliente.                 |
| user_creation_date       | DATE          | Data de criação da conta do cliente.                  |
| hub_transaction_date     | DATE          | Data da transação de dados para o registro do cliente.|
| user_status              | VARCHAR(255)  | Status da conta do cliente (por exemplo, ativo, inativo). |


### ITEM
| Nome do Campo                | Tipo de Dados | Descrição                                             |
|------------------------------|---------------|-------------------------------------------------------|
| item_id                      | BIGINT        | Identificador único para o item no pedido (PK).       |
| hub_transaction_date         | DATE          | Data da transação de dados para o registro do item.   |
| hub_index_m10_item_id       | INT           | Índice interno para o item.                           |
| item_category_id             | BIGINT        | Identificador único para a categoria do item (FK).     |
| hub_index_m10_item_category_id | INT         | Índice interno para a categoria do item.              |
| user_producer_id             | BIGINT        | Identificador único para o usuário que produziu o item (FK). |
| item_name                    | VARCHAR(255)  | Nome do item.                                         |
| item_description             | VARCHAR(255)  | Descrição do item.                                    |
| item_link                    | VARCHAR(255)  | Link do item.                                         |
| item_currency_code           | VARCHAR(3)    | Código da moeda usada para o preço do item.           |
| item_price                   | DECIMAL(10,2) | Valor do item.                                        |
| item_distribution_form       | VARCHAR(255)  | Forma de distribuição do item (digital, físico).      |
| item_status                  | VARCHAR(255)  | Status do item (por exemplo, ativo, inativo, indisponível). |
| item_creation_date           | DATE          | Data de criação do item.                              |
| item_cancellation_date       | DATE          | Data de cancelamento do item.                         |
| item_published_date          | DATE          | Data de publicação do item.                           |


### ITEM CATEGORY
| Nome do Campo                | Tipo de Dados | Descrição                                             |
|------------------------------|---------------|-------------------------------------------------------|
| item_category_id             | BIGINT        | Identificador único para a categoria do item (PK).    |
| category_description         | VARCHAR(255)  | Descrição da categoria do item.                       |
| hub_index_m10_item_category_id | INT         | Índice interno para a categoria do item.              |
| is_category_enable           | BOOLEAN       | Indica se a categoria está ativa.                    |
| item_category_name           | VARCHAR(255)  | Nome da categoria do item.                            |


### ORDER INFO
| Nome do Campo              | Tipo de Dados | Descrição                                                        |
|----------------------------|---------------|------------------------------------------------------------------|
| order_id                   | BIGINT        | Identificador único para o pedido (PK).                          |
| hub_index_m10_customer_id  | INT           | Índice interno para o cliente no pedido.                         |
| hub_index_m10_item_id      | INT           | Índice interno para o item no pedido.                            |
| hub_index_m10_order_id     | INT           | Índice interno para o pedido.                                    |
| affiliation_id             | BIGINT        | Identificador único para a afiliação associada ao pedido.         |
| hub_transaction_date       | DATE          | Data da transação de dados para o registro do pedido.             |
| order_currency_code_from   | VARCHAR(3)    | Código da moeda usado para o preço original.                     |
| order_currency_code_to     | VARCHAR(3)    | Código da moeda usado para o preço final.                        |
| order_customer_ip          | VARCHAR(255)  | Endereço IP do comprador no momento do pedido.                   |
| order_date                 | DATE          | Data de solicitação do pedido.                                   |
| order_date_time            | DATETIME      | Data e hora da solicitação do pedido.                            |
| order_origin               | VARCHAR(255)  | Origem do pedido (por exemplo, redes sociais, google, etc).      |
| order_payment_type         | VARCHAR(255)  | Meio de pagamento usado para o pedido.                           |
| order_release_date         | DATE          | Data de liberação do pedido/pagamento.                           |
| order_release_datetime     | DATETIME      | Data e hora da liberação do pedido/pagamento (incluindo hora).  |
| order_sale_type            | VARCHAR(255)  | Tipo de venda associada ao pedido (venda direta ou por afiliação). |
| order_status               | VARCHAR(255)  | Status do pedido (por exemplo, pendente, enviado, cancelado).    |
| order_value                | DECIMAL(10,2) | Valor total do pedido.                                           |
| payment_mode_description   | VARCHAR(255)  | Descrição do meio de pagamento utilizado (parcelamento, pagamento único). |
| user_affiliate_id          | BIGINT        | Identificador único para o usuário afiliado ao pedido (FK).     |
| user_buyer_id              | BIGINT        | Chave estrangeira que referencia o cliente que fez o pedido (FK). |
| user_producer_id           | BIGINT        | Identificador único para o usuário que produziu o item (FK).    |

### ORDER ITEM
| Nome do Campo        | Tipo de Dados | Descrição                                            |
|----------------------|---------------|------------------------------------------------------|
| order_item_id        | BIGINT        | Identificador único para o item de pedido (PK).      |
| hub_transaction_date | DATE          | Data da transação de dados para o registro do pedido.|
| item_id              | BIGINT        | Identificador único para o item no pedido (FK).      |
| order_id             | BIGINT        | Identificador único para o pedido ao qual o item de pedido pertence (FK). |
| order_item_value     | DECIMAL(10,2) | Valor total (quantidade * preço unitário).           |
| quantity             | INT           | Quantidade do item no pedido.                        |



