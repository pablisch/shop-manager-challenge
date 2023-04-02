require_relative './order'
require_relative './item'
require_relative './database_connection'


class OrderRepository
  def all
    sql = 'SELECT * FROM orders;'
    results = DatabaseConnection.exec_params(sql, [])
    orders = []
    results.each{ |record| orders << write_order(record) }
    return orders
  end

  def find(id)
    sql = 'SELECT * FROM orders WHERE id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)
    record = results[0]
    write_order(record)
  end

  def create(order)
    sql = 'INSERT INTO orders (customer, date) VALUES ($1, $2);'
    params = [order.customer, order.date]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM orders WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(order)
    sql = 'UPDATE orders SET customer = $1, date = $2 WHERE id = $3;'
    params = [order.customer, order.date, order.id]
    DatabaseConnection.exec_params(sql, params)
  end

  def all_order_ids
    sql = 'SELECT * FROM orders;'
    results = DatabaseConnection.exec_params(sql, [])
    orders = []
    results.each{ |record| orders << write_order(record) }
    order_ids = orders.map{ |object| object.id}
    return order_ids
  end

  def find_order_with_items(id)
    sql = 'SELECT orders.id, orders.customer, orders.date, items.id AS "item_id", items.name, items.price, items.quantity
    FROM items 
      JOIN items_orders ON items_orders.item_id = items.id
      JOIN orders ON items_orders.order_id = orders.id
      WHERE orders.id = $1;'
    params = [id]
    results = DatabaseConnection.exec_params(sql, params)
    return find(id) if results.ntuples == 0
    record = results[0]
    order = write_order(record)
    results.each do |record|
      item = Item.new
      item.id = record['item_id'].to_i
      item.name = record['name']
      item.price = record['price'].to_f
      item.quantity = record['quantity'].to_i
      order.items << item
    end
    return order
  end

  def get_all_orders_with_items
    order_ids = all_order_ids()
    all_orders_with_items = []
    order_ids.each do |id|
      order_with_items = find_order_with_items(id)
      all_orders_with_items << order_with_items
    end
    return all_orders_with_items
  end

  private

  def write_order(record)
    order = Order.new
    order.id = record['id'].to_i
    order.customer = record['customer']
    order.date = record['date']
    return order
  end
end

DatabaseConnection.connect('shop_manager_m2m') # needed to run just this file when no connection is open
repo = OrderRepository.new
repo.get_all_orders_with_items.each do |item| 
  p item
  puts
end
# p repo.get_all_orders_with_items
# res = repo.find_order_with_items(2)
# p res.items
# repo.find_order_with_items(2)