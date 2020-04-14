-- Create Orders my_orders Table
DROP TABLE IF EXISTS orders_raw;
CREATE TABLE orders_raw (
  app_id varchar(10)
  , browser_ip varchar(10)
  , buyer_accepts_marketing boolean
  , cancel_reason varchar(32)
  , cancelled_at timestamp
  , cart_token varchar(10)
  , checkout_id varchar(15)
  , checkout_token varchar(8)
  , closed_at timestamp
  , confirmed boolean
  , contact_email varchar(32)
  , created_at timestamp
  , currency varchar(3)
  , customer_locale varchar(32)
  , device_id bigint
  , email varchar(32)
  , financial_status varchar(5)
  , fulfillment_status varchar(32)
  , gateway varchar(16)
  , id bigint
  , landing_site varchar(32)
  , landing_site_ref varchar(32)
  , line_items varchar(10000)
  , location_id bigint
  , name varchar(32)
  , note varchar(32)
  , "number" bigint
  , order_number bigint
  , order_status_url varchar(50)
  , phone varchar(12)
  , processed_at timestamp
  , processing_method varchar(6)
  , reference varchar(100)
  , referring_site varchar(100)
  , source_identifier varchar(32)
  , source_name varchar(3)
  , source_url varchar(50)
  , subtotal_price varchar(18)
  , tags varchar(32)
  , taxes_included boolean
  , test boolean
  , token varchar(8)
  , total_discount varchar(32)
  , total_discounts varchar(18)
  , total_line_items_price varchar(18)
  , total_price varchar(18)
  , total_price_usd varchar(18)
  , total_tax varchar(18)
  , total_weight int
  , updated_at timestamp
  , user_id varchar(18)
)
;