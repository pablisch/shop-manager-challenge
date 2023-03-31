class Item
  attr_accessor :id, :name, :price, :quantity, :order

  def initialize
    @order = []
  end
end