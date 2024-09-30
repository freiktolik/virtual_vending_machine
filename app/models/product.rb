class Product
  attr_reader :name, :price, :quantity

  OUT_OF_STOCK = "The product is out of stock, please select the available one:\n"
  EMPTY = "You didn't enter any product, please enter the product name from vending machine:\n"

  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
  end

  def buy!
    raise InputError.new(OUT_OF_STOCK) unless in_stock?

    @quantity -= 1
  end

  def in_stock?
    @quantity > 0
  end
end