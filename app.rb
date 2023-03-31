require_relative 'lib/database_connection'
require_relative './lib/item_repository'
require_relative './lib/order_repository'


class Application
  # The Application class initializer
  # takes four arguments:
  #  * The database name to call `DatabaseConnection.connect`
  #  * the Kernel object as `io` (so we can mock the IO in our tests)
  #  * the ***Repository object (or a double of it)
  #  * the ***Repository object (or a double of it)
  def initialize(database_name, io, item_repository, order_repository)
    DatabaseConnection.connect(database_name)
    @io = io
    @item_repository = item_repository
    @order_repository = order_repository
  end


  def run
    p @order_repository.find(1)
    p @order_repository.find(2)
    p @order_repository.find(3)
    puts
    @item_repository.all.each{ |item| p item }
    puts 
    @order_repository.all.each{ |order_object| p order_object }
    # "Runs" the terminal application
    # so it can ask the user to enter some input
    # and then decide to run the appropriate action
    # or behaviour.


    # Use `@io.puts` or `@io.gets` to
    # write output and ask for user input.
  end
end


# Don't worry too much about this if statement. It is basically saying "only
# run the following code if this is the main file being run, instead of having
# been required or loaded by another file.
# If you want to learn more about __FILE__ and $0, see here: https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#Pre-defined_Variables
if __FILE__ == $0
  app = Application.new(
    'shop_manager',
    Kernel,
    ItemRepository.new,
    OrderRepository.new
  )
  app.run
end
