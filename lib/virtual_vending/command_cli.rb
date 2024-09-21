# frozen_string_literal: true
require_relative 'io_handler'
require 'pry'

module VirtualVending
  class CommandCLI
    attr_accessor :database, :service, :stream

    DEFAULT_BUY = "What do You want to buy:\n"
    PURCHASE_DENIED = "Нou do not have the enough balance to buy the product."

    def initialize(database, transaction)
      @database = database
      @service = transaction
      @stream  = InputOutputHandler.new
    end

    def call
      initialize_virtual_vending_macnine
      virtual_vendin_machine_menu
    end

    private

    def initialize_virtual_vending_macnine
      stream.print_output("VM is initialised with default following set of products".colorize(color: :yellow, mode: :bold))
      table = ::Terminal::Table.new :headings => ['Product Name', 'Price', 'Quantity'], :rows => database.product_rows
      stream.print_output(table)
    end

    def virtual_vendin_machine_menu
      user_vendin_machine_balance
      stream.print_output("Please Choose From the Following Options:\n\
      1. Enter Coins\n\
      2. Buy Product\n\
      3. Get the Change\n")
      menu_choose_action
    end

    def user_vendin_machine_balance
      stream.print_output("On your balance is: #{balance}$ \n")
    end
  
    def menu_choose_action
      choose = stream.read_input
      case choose.to_i
      when 1  then  insert_coins
      when 2  then  select_and_buy_product
      when 3  then  complete_purchase
      end
    end

    def select_and_buy_product(message: DEFAULT_BUY)
      stream.print_output(message)
      product = database.find_product(stream.read_input)
      buying_product(product)
      virtual_vendin_machine_menu
    rescue InputError => e
      select_and_buy_product(message: e.message) 
    end

    def buying_product(product)
      raise VirtualVendingError.new(PURCHASE_DENIED) unless service.enable_purchase?
      
      service.products << product
      service.products.last.buy!
    rescue VirtualVendingError => e
      stream.print_output(e.message + " Please enter the coins.".colorize(color: :yellow, mode: :bold))
      virtual_vendin_machine_menu
    end

    def insert_coins
      stream.print_output("You have entered:\n")
      coin = database.find_coin(stream.read_input.to_f)
      service.deposited_amount += coin.value
      virtual_vendin_machine_menu
    rescue InputError => e
      stream.print_output(e.message)
      insert_coins
    end

    def complete_purchase
      remaining_change, change_coins = service.change(database.coins)
      change_message = "#{"Your change:".colorize(color: :yellow, mode: :bold)} #{returned_conins(change_coins)}"
      change_message << ", and sorry we can not return #{remaining_change.to_s.colorize(color: :yellow, mode: :bold)}$" if remaining_change > 0.0
      stream.print_output(change_message)
      stream.print_output("Thank you for using our Virtual Vending. Good-Bye!")
    end

    def returned_conins(coins)
      coins.map { |value, quantity| "#{quantity} x $#{value}" }.join(', ')
    end

    def balance
      service.balance.to_s.colorize(color: :yellow, mode: :bold)
    end
  end
end
