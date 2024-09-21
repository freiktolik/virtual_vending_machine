class CheckoutOrder
  attr_accessor :products, :deposited_amount
  
  def initialize(deposited_amount: 0.0)
    @products = []
    @deposited_amount = deposited_amount * 100
  end

  def balance
    (deposited_amount - purchase_price).round(2)
  end

  def enable_purchase?
    deposited_amount > purchase_price 
  end

  def purchase_price
    products.map(&:price).sum
  end

  def change(coins)
    @change ||= CalculateChange.new(coins, balance).call
  end
end
