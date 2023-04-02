require 'item_repository'

RSpec.describe ItemRepository do

  def reset_tables
    seed_sql = File.read('spec/seeds_m2m.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_m2m_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  context "#all" do
    it "returns attr/s for all Item objects #1" do
      repo = ItemRepository.new
      items = repo.all
      expect(items.length).to eq 9
      expect(items[0].id).to eq 1
      expect(items[0].name).to eq 'Vorpal blade'
      expect(items[0].price).to eq 34.99
      expect(items[0].quantity).to eq 20
    end

    it "returns attr/s for all Item objects #2" do
      repo = ItemRepository.new
      items = repo.all
      expect(items.length).to eq 9
      expect(items[1].id).to eq 2
      expect(items[1].name).to eq 'Tardis'
      expect(items[1].price).to eq 139.5
      expect(items[1].quantity).to eq 3
    end
  end

  context "#find by id" do
    it "returns a single Order object selected by id 1" do
      repo = ItemRepository.new
      id_to_find = 1
      item = repo.find(id_to_find)
      expect(item.id).to eq 1
      expect(item.name).to eq 'Vorpal blade'
      expect(item.price).to eq 34.99
      expect(item.quantity).to eq 20
    end

    it "returns a single Order object selected by id 7" do
      repo = ItemRepository.new
      id_to_find = 7
      item = repo.find(id_to_find)
      expect(item.id).to eq 7
      expect(item.name).to eq 'Flux capacitor'
      expect(item.price).to eq 20
      expect(item.quantity).to eq 41
    end

    it "fail when there is no item selected by id 10" do
      repo = ItemRepository.new
      id_to_find = 10
      expect { item = repo.find(id_to_find) }.to raise_error "There is no such item."
    end
  end

  context "#create" do
    it "inserts a single Order object #1" do
      repo = ItemRepository.new
      item = Item.new
      item.name = 'Sonic screwdriver'
      item.price = 69.99
      item.quantity = 3
      repo.create(item)
      items = repo.all
      expect(items[-1].name).to eq 'Sonic screwdriver'
      expect(items[-1].price).to eq 69.99
      expect(items[-1].quantity).to eq 3
      expect(items[-1].id).to eq 10
    end

    it "inserts a single Order object #2" do
      repo = ItemRepository.new
      item = Item.new
      item.name = 'Light saber'
      item.price = 120
      item.quantity = 32
      repo.create(item)
      items = repo.all
      expect(items[-1].name).to eq 'Light saber'
      expect(items[-1].price).to eq 120
      expect(items[-1].quantity).to eq 32
      expect(items[-1].id).to eq 10
    end
  end

  context "#delete" do
    it "deletes a single Order object #1" do
      repo = ItemRepository.new
      id_to_delete = 1
      repo.delete(id_to_delete)
      items = repo.all 
      expect(items.length).to eq 8
      expect(items[0].id).to eq 2
    end

    it "deletes a single Order object #2" do
      repo = ItemRepository.new
      id_to_delete = 9
      repo.delete(id_to_delete)
      items = repo.all 
      expect(items.length).to eq 8
      expect(items[-1].id).to eq 8
    end
  end

  context "#update" do
    it "updates a single Order object selected by id 1" do
      repo = ItemRepository.new
      id_to_update = 1
      item = repo.find(id_to_update)
      item.name = "Vorpal letter opener"
      item.price = 5.99
      item.quantity = 26
      repo.update(item)
      updated_item = repo.find(id_to_update)
      expect(updated_item.name).to eq "Vorpal letter opener"
      expect(updated_item.price).to eq 5.99
      expect(updated_item.quantity).to eq 26
      expect(updated_item.id).to eq 1
    end

    it "updates a single Order object selected by id 3" do
      repo = ItemRepository.new
      id_to_update = 3
      item = repo.find(id_to_update)
      item.name = "Dung beetle"
      item.price = 0.1
      item.quantity = 3000
      repo.update(item)
      updated_item = repo.find(id_to_update)
      expect(updated_item.name).to eq "Dung beetle"
      expect(updated_item.price).to eq 0.1
      expect(updated_item.quantity).to eq 3000
      expect(updated_item.id).to eq 3
    end
  end

  context "#find_with_orders" do
    it "selects a single item and all associated orders based on an item id of 1 where there are no associated orders" do
      repo = ItemRepository.new
      find_by_id = 1
      item = repo.find_with_orders(find_by_id)
      expect(item.id).to eq 1
      expect(item.name).to eq 'Vorpal blade'
      expect(item.orders.length).to eq 0
    end

    it "selects a single item and all associated orders based on an item id of 2 with a single order" do
      repo = ItemRepository.new
      find_by_id = 2
      item = repo.find_with_orders(find_by_id)
      expect(item.id).to eq 2
      expect(item.name).to eq 'Tardis'
      expect(item.orders.length).to eq 1
      expect(item.orders[0].customer).to eq 'Doctor Who'
      expect(item.orders[0].date).to eq '2056-04-13'
      expect(item.orders[0].id).to eq 1
    end

    it "selects a single item and all associated orders based on an item id of 5 with multiple orders" do
      repo = ItemRepository.new
      find_by_id = 5
      item = repo.find_with_orders(find_by_id)
      expect(item.id).to eq 5
      expect(item.name).to eq 'Elder wand'
      expect(item.price).to eq 56.78
      expect(item.quantity).to eq 0
      expect(item.orders.length).to eq 2
      expect(item.orders[0].customer).to eq 'Voldermort'
      expect(item.orders[0].date).to eq '2005-04-01'
      expect(item.orders[0].id).to eq 2
      expect(item.orders[1].customer).to eq 'Harry Potter'
      expect(item.orders[1].date).to eq '2013-08-01'
      expect(item.orders[1].id).to eq 5
    end
  end

  it "returns id for all Item objects #1" do
    repo = ItemRepository.new
    expect(repo.all_ids).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
end