require 'colorize'

class String
  def to_yellow
    colorize(color: :yellow, mode: :bold)
  end
end