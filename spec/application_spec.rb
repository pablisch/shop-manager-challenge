require_relative '../app'
require 'item'
require 'item_repository'
require 'order'
require 'order_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
  connection.exec(seed_sql)
end



RSpec.describe Application do
  before(:each) do
    reset_tables
  end
  let(:io) { double(:io) }
  let(:app) { Application.new('shop_manager_test', io, ItemRepository.new, OrderRepository.new) }

  def main_menu_expectations # the code that is always run when app.rb starts
    expect(io).to receive(:puts).with("Welcome to the shop manager program.").ordered
    expect(io).to receive(:puts).with("\nWhat do you want to do?").ordered
    expect(io).to receive(:puts).with("  1 = list all shop items").ordered
    expect(io).to receive(:puts).with("  2 = create a new item").ordered
    expect(io).to receive(:puts).with("  3 = list all orders").ordered
    expect(io).to receive(:puts).with("  4 = create a new order\n\n").ordered
  end

  it "prints a welcome" do
    # expect(io).to receive(:puts).with("Welcome to the shop manager program.").ordered
    main_menu_expectations()
    expect(io).to receive(:gets).and_return("q").ordered
    expect(io).to receive(:puts).with("\nGoodbye!").ordered
    app.run
  end
  
  it "prints a welcome and exits when " do
    main_menu_expectations()
    expect(io).to receive(:gets).and_return("6").ordered
    expect(io).to receive(:puts).with("\nSorry, 6 was not an option.").ordered
    app.run
  end

  it "outputs a list of all items" do
    expect(io).to receive(:puts).with("\nCurrent shop items:\n\n")
    expect(io).to receive(:puts).with("Item  1            Vorpal blade  -  Price(£):      34.99  -  Quantity:    20")
    expect(io).to receive(:puts).with("Item  2                  Tardis  -  Price(£):     139.50  -  Quantity:     3")
    expect(io).to receive(:puts).with("Item  3           Scarab beetle  -  Price(£):      10.99  -  Quantity:   300")
    expect(io).to receive(:puts).with("Item  4  The Ultimate Nullifier  -  Price(£): 2000000.00  -  Quantity:     1")
    expect(io).to receive(:puts).with("Item  5              Elder wand  -  Price(£):      56.78  -  Quantity:     1")
    expect(io).to receive(:puts).with("Item  6           Winged helmet  -  Price(£):      14.69  -  Quantity:    45")
    expect(io).to receive(:puts).with("Item  7          Flux capacitor  -  Price(£):      20.00  -  Quantity:    41")
    expect(io).to receive(:puts).with("Item  8                   AT-AT  -  Price(£):    2350.00  -  Quantity:     2")
    expect(io).to receive(:puts).with("Item  9                 Horcrux  -  Price(£):       0.50  -  Quantity:     7")
    app.list_items
  end

  it "outputs a list of all orders" do
    expect(io).to receive(:puts).with("\nAll orders:\n\n")
    expect(io).to receive(:puts).with("# 1    Doctor Who  -  Date: 2056-04-13  -  Ordered Item Ref:  2")
    expect(io).to receive(:puts).with("# 2    Voldermort  -  Date: 2005-04-01  -  Ordered Item Ref:  9")
    expect(io).to receive(:puts).with("# 3     Chewbacca  -  Date: 1977-06-23  -  Ordered Item Ref:  1")
    expect(io).to receive(:puts).with("# 4       Perseus  -  Date: 0101-01-15  -  Ordered Item Ref:  1")
    expect(io).to receive(:puts).with("# 5  Harry Potter  -  Date: 2013-08-01  -  Ordered Item Ref:  4")
    expect(io).to receive(:puts).with("# 6        Sun Ra  -  Date: 1979-12-31  -  Ordered Item Ref:  3")
    app.list_orders
  end

  context "create new item" do
    it "goes through the process of creating a new item first time" do
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:print).with("Name for new item: ").ordered
      expect(io).to receive(:gets).and_return("spanner").ordered
      expect(io).to receive(:print).with("Price for new item: ").ordered
      expect(io).to receive(:gets).and_return("23.5").ordered
      expect(io).to receive(:print).with("Quantity for new item: ").ordered
      expect(io).to receive(:gets).and_return("50").ordered
      expect(io).to receive(:puts).with("Spanner has been added to the inventory with price set at £23.50 and quantity set to 50.").ordered
      app.create_item
    end
    
    it "goes through the process for creating a new item with unaccepted inputs" do
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:print).with("Name for new item: ").ordered
      expect(io).to receive(:gets).and_return("13").ordered
      expect(io).to receive(:puts).with("The name must contain at least one letter character.").ordered
      expect(io).to receive(:print).with("Name for new item: ").ordered
      expect(io).to receive(:gets).and_return("golden toothpick").ordered
      expect(io).to receive(:print).with("Price for new item: ").ordered
      expect(io).to receive(:gets).and_return("ten").ordered
      expect(io).to receive(:puts).with("The price cannot be 'ten'.").ordered
      expect(io).to receive(:print).with("Price for new item: ").ordered
      expect(io).to receive(:gets).and_return("10").ordered
      expect(io).to receive(:print).with("Quantity for new item: ").ordered
      expect(io).to receive(:gets).and_return("25.5").ordered
      expect(io).to receive(:puts).with("The quantity cannot be '25.5'.").ordered
      expect(io).to receive(:print).with("Quantity for new item: ").ordered
      expect(io).to receive(:gets).and_return("25").ordered
      expect(io).to receive(:puts).with("Golden toothpick has been added to the inventory with price set at £10.00 and quantity set to 25.").ordered
      app.create_item
    end
  end

  context "create new order" do
    it "goes through the process of creating a new order first time" do
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:print).with("Customer for new order: ").ordered
      expect(io).to receive(:gets).and_return("john doe").ordered
      expect(Time).to receive(:now).and_return(Time.new(2023, 04, 01)).ordered
      expect(io).to receive(:puts).with("The order date is 2023-04-01.").ordered
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:puts).with("\nCurrent shop items:\n\n")
      expect(io).to receive(:puts).with("Item  1            Vorpal blade  -  Price(£):      34.99  -  Quantity:    20")
      expect(io).to receive(:puts).with("Item  2                  Tardis  -  Price(£):     139.50  -  Quantity:     3")
      expect(io).to receive(:puts).with("Item  3           Scarab beetle  -  Price(£):      10.99  -  Quantity:   300")
      expect(io).to receive(:puts).with("Item  4  The Ultimate Nullifier  -  Price(£): 2000000.00  -  Quantity:     1")
      expect(io).to receive(:puts).with("Item  5              Elder wand  -  Price(£):      56.78  -  Quantity:     1")
      expect(io).to receive(:puts).with("Item  6           Winged helmet  -  Price(£):      14.69  -  Quantity:    45")
      expect(io).to receive(:puts).with("Item  7          Flux capacitor  -  Price(£):      20.00  -  Quantity:    41")
      expect(io).to receive(:puts).with("Item  8                   AT-AT  -  Price(£):    2350.00  -  Quantity:     2")
      expect(io).to receive(:puts).with("Item  9                 Horcrux  -  Price(£):       0.50  -  Quantity:     7")
      expect(io).to receive(:print).with("What would you like to order? [item number] ").ordered
      expect(io).to receive(:gets).and_return("4").ordered
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:puts).with("An order has been raised for John Doe. Order confirmed for item #4, The Ultimate Nullifier, on 2023-04-01.").ordered
      app.create_order
    end
    
    it "goes through the process of creating a new order with unaccepted customer input and wrong id" do
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:print).with("Customer for new order: ").ordered
      expect(io).to receive(:gets).and_return("13").ordered
      expect(io).to receive(:puts).with("The customer must contain at least one letter character.").ordered
      expect(io).to receive(:print).with("Customer for new order: ").ordered
      expect(io).to receive(:gets).and_return("jane doe").ordered
      expect(Time).to receive(:now).and_return(Time.new(2023, 04, 01)).ordered
      expect(io).to receive(:puts).with("The order date is 2023-04-01.").ordered
      expect(io).to receive(:puts).with("").ordered
      expect(io).to receive(:puts).with("\nCurrent shop items:\n\n")
      expect(io).to receive(:puts).with("Item  1            Vorpal blade  -  Price(£):      34.99  -  Quantity:    20")
      expect(io).to receive(:puts).with("Item  2                  Tardis  -  Price(£):     139.50  -  Quantity:     3")
      expect(io).to receive(:puts).with("Item  3           Scarab beetle  -  Price(£):      10.99  -  Quantity:   300")
      expect(io).to receive(:puts).with("Item  4  The Ultimate Nullifier  -  Price(£): 2000000.00  -  Quantity:     1")
      expect(io).to receive(:puts).with("Item  5              Elder wand  -  Price(£):      56.78  -  Quantity:     1")
      expect(io).to receive(:puts).with("Item  6           Winged helmet  -  Price(£):      14.69  -  Quantity:    45")
      expect(io).to receive(:puts).with("Item  7          Flux capacitor  -  Price(£):      20.00  -  Quantity:    41")
      expect(io).to receive(:puts).with("Item  8                   AT-AT  -  Price(£):    2350.00  -  Quantity:     2")
      expect(io).to receive(:puts).with("Item  9                 Horcrux  -  Price(£):       0.50  -  Quantity:     7")
      expect(io).to receive(:print).with("What would you like to order? [item number] ").ordered
      expect(io).to receive(:gets).and_return("10").ordered
      expect(io).to receive(:puts).with("Item #10 cannot be found.").ordered
      app.create_order
    end
  end
  
  it "puts text" do
    expect(io).to receive(:puts).with("Hello").ordered
    app.say("Hello")
  end
  
  it "prints text and receives a text input" do
    expect(io).to receive(:print).with("Who?").ordered
    expect(io).to receive(:gets).and_return("me").ordered
    app.ask_inline("Who?")
  end
  
  it "puts text and receives a text input" do
    expect(io).to receive(:puts).with("Who?").ordered
    expect(io).to receive(:gets).and_return("me").ordered
    app.ask("Who?")
  end


end

