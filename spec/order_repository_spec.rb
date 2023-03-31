require 'order_repository'

RSpec.describe OrderRepository do

  def reset_tables
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  context "#all" do
    it "returns attr/s for all Order objects #1" do
      repo = OrderRepository.new
      orders = repo.all # an array of orders objects
      expect(orders.length).to eq 6
      expect(orders.first.id).to eq 1
      expect(orders.first.customer).to eq 'Doctor Who'
      expect(orders.first.date).to eq '2056-04-13'
      expect(orders.first.item_id).to eq 2
    end

    it "returns attr/s for all Order objects #2" do
      repo = OrderRepository.new
      orders = repo.all # an array of orders objects
      expect(orders.length).to eq 6
      expect(orders.last.id).to eq 6
      expect(orders.last.customer).to eq 'Sun Ra'
      expect(orders.last.date).to eq '1979-12-31'
      expect(orders.last.item_id).to eq 3
    end
  end

  context "#find by id" do
    it "returns a single Order object selected by id 1" do
      repo = OrderRepository.new
      id_to_find = 1
      order = repo.find(id_to_find) # an array of orders objects
      expect(order.id).to eq 1
      expect(order.customer).to eq 'Doctor Who'
      expect(order.date).to eq '2056-04-13'
      expect(order.item_id).to eq 2
    end

    it "returns a single Order object selected by id 4" do
      repo = OrderRepository.new
      id_to_find = 4
      order = repo.find(id_to_find) # an array of orders objects
      expect(order.id).to eq 4
      expect(order.customer).to eq 'Perseus'
      expect(order.date).to eq '0101-01-15'
      expect(order.item_id).to eq 1
    end
  end

  context "#create" do
    it "inserts a single Order object #1" do
      repo = OrderRepository.new
      order = Order.new
      order.customer = 'Luke Skywalker'
      order.date = '2056-04-13'
      order.item_id = 4
      repo.create(order)
      orders = repo.all
      expect(orders[-1].id).to eq 7
      expect(orders[-1].customer).to eq 'Luke Skywalker'
      expect(orders[-1].date).to eq '2056-04-13'
      expect(orders[-1].item_id).to eq 4
    end

    it "inserts a single Order object #2" do
      repo = OrderRepository.new
      order = Order.new
      order.customer = 'The Cat in the Hat'
      order.date = '1967-11-20'
      order.item_id = 7
      repo.create(order)
      orders = repo.all
      expect(orders[-1].id).to eq 7
      expect(orders[-1].customer).to eq 'The Cat in the Hat'
      expect(orders[-1].date).to eq '1967-11-20'
      expect(orders[-1].item_id).to eq 7
    end
  end

  context "#delete" do
    it "deletes a single Order object #1" do
      repo = OrderRepository.new
      id_to_delete = 1
      repo.delete(id_to_delete)
      orders = repo.all # returns an array of all orders
      expect(orders.length).to eq 5
      expect(orders[0].id).to eq 2
    end

    it "deletes a single Order object #2" do
      repo = OrderRepository.new
      id_to_delete = 6
      repo.delete(id_to_delete)
      orders = repo.all # returns an array of all orders
      expect(orders.length).to eq 5
      expect(orders[-1].id).to eq 5
    end
  end

  context "#update" do
    it "updates a single Order object selected by id 1" do
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
      expect(updated_order.id).to eq 1
    end

    it "updates a single Order object selected by id 3" do
      repo = OrderRepository.new
      id_to_update = 3
      order = repo.find(id_to_update)
      order.customer = "Captain Marvel"
      order.item_id = 7
      repo.update(order)
      updated_order = repo.find(id_to_update)
      expect(updated_order.customer).to eq "Captain Marvel"
      expect(updated_order.date).to eq "1977-06-23"
      expect(updated_order.item_id).to eq 7
      expect(updated_order.id).to eq 3
    end
  end
end