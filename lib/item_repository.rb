require_relative './item'
require_relative './order'

class ItemRepository
  def all
    sql = 'SELECT * FROM items;'
    results = DatabaseConnection.exec_params(sql, [])
    items = []
    results.each{ |record| items << write_item(record) }
    return items
  end

  def find(id)
    sql = 'SELECT * FROM items WHERE id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)
    record = results[0]
    write_item(record)
  end

  def create(item)
    sql = 'INSERT INTO items (name, price, quantity) VALUES ($1, $2, $3);'
    params = [item.name, item.price, item.quantity]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM items WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(item)
    sql = 'UPDATE items SET name = $1, price = $2, quantity = $3 WHERE id = $4'
    params = [item.name, item.price, item.quantity, item.id]
    DatabaseConnection.exec_params(sql, params)
  end

  def find_with_orders(id)
    sql = 'SELECT items.id, items.name, items.price, items.quantity, orders.customer, orders.date, orders.id AS "order_id"
    FROM items
    JOIN orders
    ON orders.item_id = items.id
    WHERE items.id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)
    return find(id) if results.ntuples == 0
    record = results[0]
    item = write_item(record)
    item.orders = []
    results.each do |record|
      order = Order.new
      order.id = record['order_id'].to_i
      order.customer = record['customer']
      order.date = record['date']
      item.orders << order
    end
    return item
  end

  private

  def write_item(record)
    item = Item.new
    item.id = record['id'].to_i
    item.name = record['name']
    item.price = record['price'].to_f
    item.quantity = record['quantity'].to_i
    return item
  end
end