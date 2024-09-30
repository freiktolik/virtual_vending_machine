require 'pry'
require 'terminal-table'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec/' # Ignore spec files
  add_group 'models', 'app/models'
  add_group 'services', 'app/services'
  add_group 'errors', 'app/errors'
  add_group 'lib', 'lib'
end

require 'support/string'

# Add the virtual_vending_machine/app directory to the $LOAD_PATH
$LOAD_PATH.unshift(File.expand_path('../app', __FILE__))

# Require all Ruby files from virtual_vending_machine/app recursively
Dir[File.join(File.dirname(__FILE__), '../app', '**', '*.rb')].sort.each do |file|
  require_relative file
end

$database = Database.instance

require_relative '../lib/virtual_vending/command_cli'
require_relative '../lib/virtual_vending/io_handler'

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random

  # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!

  # Print the 10 slowest examples and example groups at the end of the spec run
  config.profile_examples = 5
end

SimpleCov.minimum_coverage 90
