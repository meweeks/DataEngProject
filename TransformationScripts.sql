--SQL Transformation Scripts 
-- Create User Table

DROP TABLE IF EXISTS users_table;
CREATE TABLE users_table AS
WITH user_calcs AS (
  SELECT 
    distinct g.user_id
    , count(g.order_number) OVER (PARTITION BY user_id) AS num_orders
    , min(g.created_at) OVER(PARTITION BY user_id) AS first_order_timestamp
    , max(g.created_at) OVER(PARTITION BY user_id) AS last_order_timestamp
  FROM orders_raw AS g
), last_order_facts AS (
  SELECT
    u.user_id
    , o.email
    , o.phone
    , o.location_id
    , u.last_order_timestamp
    , o.name last_order_product
    , o.buyer_accepts_marketing 
  FROM user_calcs u
  LEFT JOIN orders_raw o ON u.user_id = o.user_id AND u.last_order_timestamp = o.created_at
), first_order_facts AS (
  SELECT
    u.user_id
    , u.first_order_timestamp
    , o.name first_order_product
  FROM user_calcs u
  LEFT JOIN orders_raw o ON u.user_id = o.user_id AND u.first_order_timestamp = o.created_at
)
SELECT 
  u.user_id
  , l.email
  , l.phone
  , l.location_id
  , l.buyer_accepts_marketing
  , f.first_order_timestamp
  , f.first_order_product
  , l.last_order_timestamp
  , l.last_order_product
  , u.num_orders
  FROM user_calcs u
  LEFT JOIN last_order_facts l ON l.user_id = u.user_id
  LEFT JOIN first_order_facts f ON f.user_id = u.user_id;

-- Create Orders Table
DROP TABLE IF EXISTS orders_table;
CREATE TABLE orders_table AS
SELECT 
  id AS transaction_id
  , order_number
  , round(checkout_id::numeric) AS checkout_id
  , location_id
  , gateway AS payment_type
  , CASE WHEN checkout_id IS NOT NULL THEN True ELSE False END AS is_online_order
  , name AS product
  , created_at
  , processed_at
  , updated_at
  , cancelled_at
  , cancel_reason AS cancellation_reason
  , processing_method
  , round(subtotal_price::numeric,2) AS subtotal_price
  , round(total_discounts::numeric,2) AS total_discounts
  , round(total_line_items_price::numeric,2) AS total_line_items_price
  , round(total_price::numeric,2) AS total_price
  , round(total_price_usd::numeric,2) AS total_price_usd
  , round(total_tax::numeric,2) AS total_tax
  , total_weight  
FROM orders_raw
WHERE test = FALSE;