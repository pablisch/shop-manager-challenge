{{🦠 shop_manager : 🦠 items }} Model and Repository Classes Design Recipe for the ONE table of a ONE-to-MANY relationship.

## NOTES:

> Make sure that the {DATABASE NAME} has been entered into the appropriate places in:
> spec_helper.rb > DatabaseConnection.connect('your_database_name_test')

## 1. Design and create the Table

Table:

| Record	   | Properties               |
| ---------- | ------------------------ |
| items	     | name, price, quantity    |
| orders	   | customer, date, item_id  |

🦠 Create the table AND table_test and insert data from seed: 
```bash
psql -h 127.0.0.1

pablo=# CREATE DATABASE music_library
pablo=# CREATE DATABASE music_library_test

psql -h 127.0.0.1 your_database_name < {table_name}.sql
psql -h 127.0.0.1 your_database_name_test < {table_name}.sql
```

## 2. Create Test SQL seeds

-- (file: spec/seeds_{table_name}.sql)
>> spec/seeds_xxx.sql

```sql
TRUNCATE TABLE xxx RESTART IDENTITY; -- 🦠 TABLE NAME! 🦠 replace with your own table name.

INSERT INTO xxx (attr1, attr2, xxx_id) VALUES ('...', '...', 1);
INSERT INTO xxx (attr1, attr2, xxx_id) VALUES ('...', '...', 1);
```

To insert this data into your test database => psql -h 127.0.0.1 <your_database_name>_test < seeds_{table_name}.sql

## 3. Define the class names
Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

```ruby
class Item
end

class ItemRepository
end
```

## 4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class Item
  attr_accessor :id, :name, :price, :quantity
end
```

## 5. Define the Repository Class interface
```ruby
# 1 repository class FILE lib/xxx_repository.rb
class ItemRepository
# return all xxx objects from table
  def all
    # executes the SQL query:
    # SELECT * FROM items;
    # returns an array of item objects as hashes
  end

# Find and return a single xxx object
  def find(id)
    # executes the SQL query:
    # SELECT attr1, attr2, etc. FROM xxx WHERE id = $1;
    # returns an array of item objects as hashes
  end
end

# Create a new xxx object. Returns nothing
  def create(item)
    # executes the SQL query:
    # INSERT INTO xxx (attr1, attr2, etc) VALUES ($1, $2, $3);
  end

# delete an xxx object identified by id. Returns nothing
  def delete(id)
    # executes the SQL query:
    # DELETE FROM xxx WHERE id = $1;
  end

# update an xxx object identified by id. Returns nothing
  def update(item)
    # executes the SQL query:
    # UPDATE xxx SET attr1 = $1, attr2 = $2 WHERE id = $3;
  end

# update an xxx object identified by id. Returns nothing
  def find_with_orders(id)
    # executes the SQL query:
    # SELECT items.id AS "item_id", items.name, items.price, items.quantity, orders.title, orders.release_year, orders.id AS "orders_id"
    # FROM items
    # JOIN orders
    # ON orders.item_id = items.id
    # WHERE items.id = $1;
  end
end
```

## 6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.
```ruby
# 1 return all
repo = ItemRepository.new
items = repo.all
expect(items.length).to eq 9
expect(items.first.id).to eq 1
expect(items.first.name).to eq 'Vorpal blade'
expect(items.first.price).to eq 34.99
expect(items.first.quantity).to eq 20

# 2 find a single item by id
repo = ItemRepository.new
id_to_find = 1
item = repo.find(id_to_find)
expect(item.id).to eq 1
expect(item.name).to eq 'Vorpal blade'
expect(item.price).to eq 34.99
expect(item.quantity).to eq 20

# 3 create new item
repo = ItemRepository.new
item = Item.new
item.name = 'Sonic screwdriver'
item.price = 69.99
item.quantity = 3
repo.create(item)
items = repo.all
expect(items[-1].name).to eq 'Title'
expect(items[-1].price).to eq 69.99
expect(items[-1].quantity).to eq 3
expect(items[-1].id).to eq 10

# 4 delete item
repo = ItemRepository.new
id_to_delete = 1
repo.delete(id_to_delete)
items = repo.all 
expect(items.length).to eq 8
expect(items[0].id).to eq 2

# 5 update item
repo = ItemRepository.new
id_to_update = 3
item = repo.find(id_to_update)
item.name = "Dung beetle"
item.price = 0.1
item.quantity = 3000
repo.update(item)
updated_item = repo.find(id_to_update)
expect(updated_item.name).to eq "Dung beetle"
expect(updated_item.price).to eq 0.1
expect(updated_item.quantity).to eq 3000
expect(updated_item.id).to eq 9

# 6 SELECT a single item and all associated orders
repo = ItemRepository.new
find_by_id = 1
item = repo.find_with_order(find_by_id)
expect(item.id).to eq 1
expect(item.name).to eq 'Vorpal blade'
expect(item.orders.length).to eq 2
expect(item.orders[0].customer).to eq 'Chewbacca'
expect(item.orders[0].date).to eq '1977-06-23'
expect(item.orders[0].item_id).to eq 1
```

## 7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.
```ruby
require 'item_repository'

RSpec.describe ArtistRepository do

  def reset_table # reload method
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_table # reloads for each test
  end

  it "" do # first test
  end
end
```

end

## 8. CHECK:

> That all the relevant requires are in place:

> {TABLE}_REPOSITORY.rb > require_relative '{table}'

> {TABLE}_REPOSITORY_SPEC.rb > require '{table}_repository'

> APP.RB > require_relative 'lib/database_connection'
         > require_relative 'lib/{table}_repository'

> SPEC_HELPER.RB > database_connection.rb

> DATABASE_CONNECTION.RB > require 'pg'

## 9. Test-drive and implement the Repository class behaviour
After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.