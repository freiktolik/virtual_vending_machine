require 'pry'
require 'thor'
require 'terminal-table'
require 'colorize'
require 'yaml'

require_relative '../app/db/database'
require_relative '../app/services/checkout_order'
require_relative '../app/services/calculate_change'
require_relative '../app/errors/input_error'
require_relative '../app/errors/virtual_vending_error'
require_relative './virtual_vending/command_cli'

products = YAML.load_file("config/stock.yml").transform_keys(&:to_sym)
coins = YAML.load_file("config/coins.yml").transform_keys(&:to_sym)

database = Database.instance
database.configure(products, coins)

VirtualVending::CommandCLI.new(database, CheckoutOrder.new()).()
