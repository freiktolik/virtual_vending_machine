class Coin
  COINS_INPUT_ERROR = "You didn't enter any coins\n".freeze
  INVALID_COINS = "Invalid coin\n".freeze

  attr_accessor :quantity
  attr_reader :value  

  def initialize(value, quantity)
    @value = value
    @quantity = quantity
  end

  def deduct(count)
    raise "Not enough coins" if count > @quantity

    @quantity -= count
  end

  def add(count)
    @quantity += count
  end
end
