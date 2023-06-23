DROP TABLE IF EXISTS items, orders, items_orders; 

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name text,
  price numeric,
  quantity int
);

-- Create the second table.
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer text,
  date date
);

-- Create the join table.
CREATE TABLE items_orders (
  item_id int,
  order_id int,
  constraint fk_item foreign key(item_id) references items(id) on delete cascade,
  constraint fk_order foreign key(order_id) references orders(id) on delete cascade,
  PRIMARY KEY (item_id, order_id)
);

-- createdb shop_manager_m2m
-- createdb shop_manager_m2m_test
-- psql -h 127.0.0.1 shop_manager_m2m < spec/shop_manager_m2m_tables.sql
-- psql -h 127.0.0.1 shop_manager_m2m_test < spec/shop_manager_m2m_tables.sql
-- psql -h 127.0.0.1 shop_manager_m2m < spec/seeds_m2m.sql
-- psql -h 127.0.0.1 shop_manager_m2m_test < spec/seeds_m2m.sql
