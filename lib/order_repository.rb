require_relative './order'

class OrderRepository
  def all
    sql = 'SELECT * FROM orders;'
    results = DatabaseConnection.exec_params(sql, [])
    orders = []
    results.each do |record|
      orders << write_order(record)
    end
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
    sql = 'INSERT INTO orders (customer, date, item_id) VALUES ($1, $2, $3);'
    params = [order.customer, order.date, order.item_id]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM orders WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
  end

  def update(order)
    sql = 'UPDATE orders SET customer = $1, date = $2, item_id = $3 WHERE id = $4;'
    params = [order.customer, order.date, order.item_id, order.id]
    DatabaseConnection.exec_params(sql, params)
  end

  private

  def write_order(record)
    order = Order.new
    order.id = record['id'].to_i
    order.customer = record['customer']
    order.date = record['date']
    order.item_id = record['item_id'].to_i
    return order
  end
end