{{🦠 shop_manager : 🦠 orders }} Model and Repository Classes Design Recipe for the MANY table of a ONE-to-MANY relationship.

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
class Order
end

class OrderRepository
end
```

## 4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class Order
  attr_accessor :id, :customer, :date, :item_id
end
```

## 5. Define the Repository Class interface
```ruby
# 1 repository class FILE lib/xxx_repository.rb
class OrderRepository
# return all xxx objects from table
  def all
    # executes the SQL query:
    # SELECT * FROM artists;
    # returns an array of album objects as hashes
  end

# Find and return a single xxx object
  def find(id)
    # executes the SQL query:
    # SELECT attr1, attr2, etc., <many-class>_id FROM xxx WHERE id = $1;
    # returns an array of album objects as hashes
  end
end

# Create a new xxx object. Returns nothing
  def create(album)
    # executes the SQL query:
    # INSERT INTO xxx (attr1, attr2, etc, <many-class>_id) VALUES ($1, $2, $3);
  end

# delete an xxx object identified by id. Returns nothing
  def delete(id)
    # executes the SQL query:
    # DELETE FROM xxx WHERE id = $1;
  end

# update an xxx object identified by id. Returns nothing
  def update(album)
    # executes the SQL query:
    # UPDATE xxx SET attr1 = $1, attr2 = $2 WHERE id = $3;
  end
end
```

## 6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.
```ruby
# 1 return all
repo = OrderRepository.new
orders = repo.all # an array of orders objects
expect(orders.length).to eq 6
expect(orders.first.id).to eq 1
expect(orders.first.customer).to eq 'Doctor Who'
expect(orders.first.date).to eq '2056-04-13'
expect(orders.first.item_id).to eq 2

# 2 find a single order by id
repo = OrderRepository.new
id_to_find = 1
order = repo.find(id_to_find) # an array of orders objects
expect(order.id).to eq 1
expect(order.customer).to eq 'Doctor Who'
expect(order.date).to eq '2056-04-13'
expect(order.item_id).to eq 2

# 3 create new order
repo = OrderRepository.new
order = Order.new
order.customer = 'Luke Skywalker'
order.release_year = '1976'
order.item_id = '4'
repo.create(order)
orders = repo.all
expect(orders[-1].id).to eq 7
expect(orders[-1].customer).to eq 'Luke Skywalker'
expect(orders[-1].date).to eq '2056-04-13'
expect(orders[-1].item_id).to eq 2

# 4 delete order
repo = OrderRepository.new
id_to_delete = 1
repo.delete(id_to_delete)
orders = repo.all # returns an array of all orders
expect(orders.length).to eq 5
expect(orders[0].id).to eq 2

# 5 update order
repo = OrderRepository.new
id_to_update = 1
order = repo.find(id_to_update)
order.customer = "Davros"
order.date = "1066-02-12"
order.item_id = 8
repo.update(order)
updated_order = repo.find(id_to_update)
expect(updated_order.customer).to eq "Davros"
expect(updated_order.date).to eq "1066-02-12"
expect(updated_order.item_id).to eq 8
expect(updated_order.id).to eq 6
```

## 7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.
```ruby
require 'artist_repository'

RSpec.describe ArtistRepository do

  def reset_artists_table # reload method
    seed_sql = File.read('spec/seeds_artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_artists_table # reloads for each test
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