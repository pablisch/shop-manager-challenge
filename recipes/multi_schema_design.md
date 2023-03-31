Multi Table Design Recipe Template

DBs: shop_manager AND shop_manager_test

## 1. Extract nouns from the user stories or specification

As a shop manager
So I can know which items I have in stock
I want to keep a {list of} my shop [items] with their [item_name] and [unit_price].

As a shop manager
So I can know which items I have in stock
I want to know which [quantity] (a number) I have for each item.

As a shop manager
So I can manage items
I want to be able to create a new item.

As a shop manager
So I can know which orders were made
I want to keep a {list of} [orders] with their [customer_name].

As a shop manager
So I can know which orders were made
I want to assign each <order><to their corresponding><item>.

As a shop manager
So I can know which orders were made
I want to know on which [date] an order was placed. 

As a shop manager
So I can manage orders
I want to be able to create a new order.

> Nouns: items item_name unit_price quantity orders customer_name date
 
> items: name unit_price quantity
> orders: customer date

## 2. Infer the Table Name and Columns
Put the different nouns in this table. Replace the example with your own nouns.

| Record	   | Properties             |
| ---------- | ---------------------- |
| items	     | name, price, quantity  |
| orders	   | customer, date         |

## 3. Decide the column types.
Here's a full documentation of [PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either text, int, bigint, numeric, or boolean. If you're in doubt, do some research or ask your peers.

## 4. Decide on The Tables Relationship
Most of the time, you'll be using a one-to-many relationship, and will need a foreign key on one of the two tables.

Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No) Yes
Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

## 5. Write the SQL.

-- EXAMPLE
-- file: albums_table.sql
```sql
CREATE TABLE items (   -- the table that represents one, NOT many
  id SERIAL PRIMARY KEY,
  name text,
  price numeric,
  quantity int
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
```
## 6. Create the table.
psql -h 127.0.0.1 database_name < albums_table.sql