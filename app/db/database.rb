# frozen_string_literal: true

require 'singleton'

require_relative '../models/product'
require_relative '../models/coin'

# Database class defined for storing all information about products, coins
class Database
  include Singleton

  PRODUCTS = :products
  COINS = :coins

  TABLES = [PRODUCTS, COINS]

  def configure(*tables)
    build_products(tables.find {|table| table[PRODUCTS]}[PRODUCTS])
    build_coins(tables.find {|table| table[COINS]}[COINS])
  end

  def reset
    initialize_database
  end

  attr_accessor :products, :coins

  def product_rows
    products.map {|p| [p.name, p.price, p.quantity]}
  end

  def find_product(name)
    raise InputError.new(Product::EMPTY) if name.empty?
    
    product = products.find {|product| product.name == name}
    
    raise InputError.new("There is no product: #{name.colorize(color: :yellow, mode: :bold)} in vending machine, please select another one:\n") if product.nil?
    raise InputError.new(Product::OUT_OF_STOCK) if !product.in_stock?
    
    product
  end

  def find_coin(value)
    raise InputError.new(Coin::COINS_INPUT_ERROR) unless value > 0.0
      
    coin = coins.find {|coin| coin.value == value}
    raise InputError.new(Coin::INVALID_COINS) unless coin
    
    coin
  end

  private

  def initialize
    initialize_database
  end

  def initialize_database
    TABLES.each do |table|
      instance_variable_set("@#{table}", [])
    end
  end

  def build_products(attrs)
    attrs.map{|name, values| products << Product.new(name, values["price"], values["quantity"])}
  end

  def build_coins(attrs)
    attrs.map {|k,v | coins << Coin.new(k, v)}
  end
end
