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
    # clear()
    say "Welcome to the shop manager program."
    end_program = false
    until end_program
      user_action = main_menu()
      end_program = true if user_action == "exit"
      # end_program = true
      # loop do 
        
      #   break
      # end
    # end_program = true
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
      when "9"
        # clear()
        say "\nGoodbye!"
        return "exit"
        # exit ### ALSO EXITS RSPEC TESTS IF UNCOMMENTED
      else
        # clear()
        say "\nSorry, #{main_choice} was not an option."
        # main_menu()
    end
  end

  def list_items
    # clear()
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
    # clear()
    say "\nAll orders:\n\n"
    @order_repository.all.each do |purchase|
      say "#%2.i %13.13s  -  Date: %10.10s  -  Ordered Item Ref: %2.i" % [purchase.id, purchase.customer, purchase.date, purchase.item_id] 
    end
  end

  def create_item
    # clear()
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
    # clear()
    order = Order.new
    say ""
    order.customer = get_string_for("customer", "order").gsub(/\w+/){ |word| word.capitalize }
    order.date = Time.now.strftime("%Y-%m-%d")
    say "The order date is #{order.date}."
    list_items()
    say ""
    item_requested = ask_inline "What would you like to order? [item number] "
    request_return = item_available?(item_requested)
    if request_return[1] == "NA"
      say "Item ##{item_requested} cannot be found."
    elsif request_return[0] > 0
      order.item_id = item_requested
      p order
      @order_repository.create(order)
      say "An order has been raised for #{order.customer}. Order confirmed for item ##{item_requested}, #{request_return[1]}, on #{order.date}."
    else 
      say "Sorry, item ##{item_requested}, #{request_return[1]}, is no longer in stock."
    end
  end

  def get_string_for(attribute, item_or_order)
    loop do
      str = ask_inline "#{attribute.capitalize} of new #{item_or_order}: "
      return str if str.scan(/[a-zA-Z]/).length > 0
      say "The #{attribute} must contain at least one letter character."
    end
  end

  def get_number_for(attribute, item_or_order)
    loop do
      num = ask_inline "#{attribute.capitalize} of new #{item_or_order}: "
      return num if num.to_s.match?(/^(\d{1,8}\.?\d{0,2})$/) && attribute == "price"
      return num if num.to_s.match?(/^(\d{1,8})$/)
      say "The #{attribute} cannot be '#{num}'."
    end
  end

  def item_available?(id)
    exists = @item_repository.all_ids
    if exists.include?(id.to_i)
      item = @item_repository.find(id)
      stock = item.quantity
      if stock >= 1
        item.quantity -= 1
        @item_repository.update(item)
      end
      return [stock, item.name]
    else
      stock = 0
      return [stock, "NA"]
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
end

if __FILE__ == $0
  app = Application.new(
    'shop_manager',
    Kernel,
    ItemRepository.new,
    OrderRepository.new
  )
  app.run
end
