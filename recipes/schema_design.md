Single Table Design Recipe Template

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

album, title, release year
## 2. Infer the Table Name and Columns
Put the different nouns in this table. Replace the example with your own nouns.

| Record	   | Properties           |
| ---------- | -------------------- |
| items	     | price, quantity      |

## 3. Decide the column types.
Here's a full documentation of [PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).
Most of the time, you'll need either text, int, bigint, numeric, or boolean. If you're in doubt, do some research or ask your peers.

id: SERIAL
title: text
release_year: int
1. Write the SQL.
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, columm names and types.

CREATE TABLE albums (
  id SERIAL PRIMARY KEY,
  title text,
  release_year int
);
5. Create the table.
psql -h 127.0.0.1 database_name < albums_table.sql