class Order
  attr_accessor :id, :customer, :date, :item_id, :items

  def initialize
    @items = []
  end
end