# frozen_string_literal: true

class VirtualVendingError < StandardError
  ERROR_MESSAGE = 'Virtual Vending Machine Error'

  def initialize(message = ERROR_MESSAGE)
    super
  end
end
