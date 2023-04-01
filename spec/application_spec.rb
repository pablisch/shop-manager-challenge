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

  it "prints a welcome" do
    expect(io).to receive(:puts).with("Welcome to the shop manager program.").ordered
    expect(io).to receive(:puts).with("\nWhat do you want to do?").ordered
    expect(io).to receive(:puts).with("  1 = list all shop items").ordered
    expect(io).to receive(:puts).with("  2 = create a new item").ordered
    expect(io).to receive(:puts).with("  3 = list all orders").ordered
    expect(io).to receive(:puts).with("  4 = create a new order").ordered
    expect(io).to receive(:puts).with("  9 = quit shop manager program\n\n").ordered
    expect(io).to receive(:gets).and_return("9").ordered
    expect(io).to receive(:puts).with("\nGoodbye!").ordered
    # expect(io).to receive(:puts).with("\nSorry, 5 was not an option.").ordered
    app.run
    
    
    
  end

end

# describe Application do
#   let(:i_repo) { double(:item_repository)}
#   # let(:c_repo) { double(:customer_repository)}
#   let(:o_repo) { double(:order_repository)}
#   let(:io) { double(:io) }
#   let(:app) { Application.new('shop_manager_test', io, i_repo, o_repo)}

#   context 'when checked for UI messages' do
#     ### This section checks the UI messages ###
#     it 'displays a choice menu to user and returns their result' do
#       # app.run
#       expect(io).to receive(:puts).with("Welcome to the shop!")
#       app.run
#     end
#   end
# end













# def create_app(io)
#   return Application.new(
#     'items_orders_test',
#     io,
#     @item_repository,
#     @order_repository
#   )
# end

# RSpec.describe Application do
#   before(:each) do 
#     reset_tables
#     @item_repository = ItemRepository.new
#     @order_repository = OrderRepository.new
#   end

#   xit "prints the menu" do
#     io = double :io
#     expect(io).to receive(:puts)
#       .with('Welcome to the shop!')
#         .ordered
#     # expect(io).to receive(:puts)
#     #   .with('What would you like to do?')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('1 - List all items')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('2 - List all items attached to an order')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('3 - Create a new item')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('4 - List all orders')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('5 - List all orders that contain a specific item')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('6 - Create a new order')
#     #     .ordered
#     # expect(io).to receive(:puts)
#     #   .with('7 - Exit')
#     #     .ordered

#     app = create_app(io)
#     app.print_menu
#   end
# end