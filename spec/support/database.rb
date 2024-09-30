require 'yaml'

products = YAML.load_file("config/stock.yml").transform_keys(&:to_sym)
coins = YAML.load_file("config/coins.yml").transform_keys(&:to_sym)

RSpec.configure do |config|
  config.before(:each) do |example|
    $database.configure(products, coins)
  end

  config.after(:each) do |example|
    $database.reset
  end
end

