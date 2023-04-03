require_relative 'lib/database_connection'
require_relative './lib/item_repository'
require_relative './lib/order_repository'
require_relative './lib/item'
require_relative './lib/order'

class Application
  def initialize(database_name, io, item_repository, order_repository)
    DatabaseConnection.connect(database_name)
    @io = io
    @item_repository = item_repository
    @order_repository = order_repository
  end

  def run
    clear()
    say "Welcome to the shop manager program."
    end_program = false
    until end_program
      user_action = main_menu()
      end_program = true if user_action == "exit"
      # end_program = true ### UNCOMMENT THIS LINE WHEN RUNNING RSPEC ###
    end
  end

  def main_menu
    say "\nWhat do you want to do?"
    say "  1 = list all shop items"
    say "  2 = create a new item"
    say "  3 = list all orders"
    main_menu_handler(ask "  4 = create a new order\n\n")
  end

  def main_menu_handler(main_choice)
    case main_choice
      when "1"
        list_items()
      when "2"
        create_item()
      when "3"
        list_orders()
      when "4"
        create_order()
      when "reset"
        reset_items_and_orders()
      when "q"
        clear()
        say "\nGoodbye!"
        return "exit"
      else
        clear()
        say "\nSorry, #{main_choice} was not an option."
    end
  end

  def list_items
    clear()
    say "\nCurrent shop items:\n\n"
    items = @item_repository.all.sort_by{ |item| item.id }
    items.each do |item|
      if item.quantity == 0
        say "Item %2.i %23.23s  -  Price(£): %10.2f  -  Quantity:     0" % [item.id, item.name, item.price]
      else
        say "Item %2.i %23.23s  -  Price(£): %10.2f  -  Quantity: %5.i" % [item.id, item.name, item.price, item.quantity] 
      end
      
    end
  end

  def list_orders
    clear()
    say "\nAll orders:\n\n"
    orders = @order_repository.get_all_orders_with_items
    orders.each_with_index do |record, index|
      ordered_items = record.items.map{ |item| item.name }
      say "#%2.i %13.13s  -  Date: %10.10s  -  Order item/s: #{ordered_items.join(", ")}" % [record.id, record.customer, record.date] 
    end
  end

  def create_item
    clear()
    item = Item.new
    say ""
    name = get_string_for("name", "item").capitalize
    price = get_number_for("price", "item").to_f
    quantity = get_number_for("quantity", "item").to_i
    quantity = 99999 if quantity >= 100000
    item.name, item.price, item.quantity = name, price, quantity
    @item_repository.create(item)
    say "#{name} has been added to the inventory with price set at £%.2f and quantity set to #{quantity}." % [price]
  end

  def create_order
    clear()
    new_order = Order.new
    say ""
    new_order.customer = get_string_for("customer", "order").gsub(/\w+/){ |word| word.capitalize }
    new_order.date = Time.now.strftime("%Y-%m-%d")
    say "The order date is #{new_order.date}."
    list_items()
    say ""
    item_requested = ask_inline "What would you like to order? [item number] "
    availability_hash = item_available?(item_requested) # checks availability and updates quantity
    order_creation_handling(availability_hash, new_order) # creates order if item is available
  end

  def order_creation_handling(availability_hash, new_order)
    if availability_hash[:item_name] == "NA"
      say "Item ##{availability_hash[:item_id]} cannot be found."
    elsif availability_hash[:stock] > 0
      new_order.item_id = availability_hash[:item_id]
      @order_repository.create(new_order)
      @order_repository.update_join_table(new_order.item_id)
      say ""
      say "An order has been raised for #{new_order.customer}. Order confirmed for item ##{availability_hash[:item_id]}, #{availability_hash[:item_name]}, on #{new_order.date}."
    else 
      say "Sorry, item ##{availability_hash[:item_id]}, #{availability_hash[:item_name]}, is no longer in stock."
    end
  end

  def item_available?(id)
    exists = @item_repository.all_ids # returns an array of item ids
    if exists.include?(id.to_i)
      return update_items_when_ordering(id) # returns a hash { stock:, item_id:, item_name:}
    else
      return { stock: 0, item_id: id, item_name: "NA" } # previously => [stock, "NA"]
    end
  end

  def update_items_when_ordering(id)
    item = @item_repository.find(id) # find requested item by id
    stock = item.quantity
    if stock >= 1
      item.quantity -= 1 # check stock and reducd by one if possible
      @item_repository.update(item) # update items list
    end
    return { stock: stock, item_id: id, item_name: item.name } # previously => [stock, item.name]
  end

  def get_string_for(attribute, item_or_order)
    loop do
      str = ask_inline "#{attribute.capitalize} for new #{item_or_order}: "
      return str if str.scan(/[a-zA-Z]/).length > 0
      say "The #{attribute} must contain at least one letter character."
    end
  end

  def get_number_for(attribute, item_or_order)
    # ↓ loop to keep requesting for number until validated
    loop do
      num = ask_inline "#{attribute.capitalize} for new #{item_or_order}: "
      # ↓ up to eight digits with possible decimal point and up to two decimal places
      return num if num.to_s.match?(/^(\d{1,8}\.?\d{0,2})$/) && attribute == "price"
      # ↓ up to eight digits
      return num if num.to_s.match?(/^(\d{1,8})$/) 
      say "The #{attribute} cannot be '#{num}'."
    end
  end


  def clear
    system("clear")
  end

  def say(message)
    @io.puts(message)
  end

  def ask(question)
    @io.puts(question)
    @io.gets.chomp
  end

  def ask_inline(question)
    @io.print(question)
    @io.gets.chomp
  end

  def reset_items_and_orders
    seed_sql = File.read('spec/seeds_m2m.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_m2m' })
    connection.exec(seed_sql)
  end
end

if __FILE__ == $0
  app = Application.new(
    'shop_manager_m2m',
    Kernel,
    ItemRepository.new,
    OrderRepository.new
  )
  app.run
end
