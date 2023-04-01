require_relative 'lib/database_connection'
require_relative './lib/item_repository'
require_relative './lib/order_repository'


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
      main_menu()
      # loop do 
        
      #   break
      # end
    end_program = true
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
        list(main_choice)
      when "2"
        create(main_choice)
      when "9"
        # clear()
        say "\nGoodbye!"
        # exit ### ALSO EXITS RSPEC TESTS IF UNCOMMENTED
      else
        # clear()
        say "\nSorry, #{main_choice} was not an option."
        # main_menu()
    end
  end

  def list(choice)
    # clear()
    items = choice
    say "list #{items}"
  end

  def create(choice)
    say "You chose #{choice}"
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
