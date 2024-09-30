class CalculateChange

  class << self
    def call(*args)
      new(*args).call
    end
  end

  def call
    remaining_change = balance
  
    sorted_coins.each do |coin|
      next if coin.value > remaining_change || coin.quantity <= 0

      # Determine the maximum number of this coin we can use
      max_usable_coins = [coin.quantity, (remaining_change / coin.value).floor].min
 
      if max_usable_coins > 0
        coin.quantity -= max_usable_coins
        change_coins[coin.value] = max_usable_coins
        remaining_change -= (max_usable_coins * coin.value)
      end
    end

    [remaining_change.round(2), change_coins]
  end

  private

  attr_reader :coins, :balance
  attr_accessor :change_coins

  def initialize(coins, balance)
    @coins = coins
    @balance = balance
    @change_coins = {}
  end

  def sorted_coins
    # Sort coins by value in descending order for the Greedy Algorithm
    coins.sort_by { |coin| -coin.value }
  end
end
