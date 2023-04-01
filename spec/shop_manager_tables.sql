CREATE TABLE items (   -- the table that represents one, NOT many
  id SERIAL PRIMARY KEY,
  price money,
  quantity int,
);

-- Then the table with the foreign key first.
CREATE TABLE orders (   -- the table that can represent many, NOT one
  id SERIAL PRIMARY KEY,
  customer text,
  date date,
-- The foreign key name is always {other_table_singular}_id
  item_id int,
  constraint fk_item foreign key(item_id)
    references items(id)
    on delete cascade
);