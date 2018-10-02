require_relative 'dealer.rb'
require 'pry'

class Player < Dealer
  def initialize(name)
    binding.pry
    super(name)
  end
end
