# frozen_string_literal: true

class InputError < StandardError
  ERROR_MESSAGE = 'Invalid input parameters'

  def initialize(message = ERROR_MESSAGE)
    super
  end
end
