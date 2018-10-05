require_relative 'dealer.rb'
require 'pry'

class Player < Dealer
  def initialize(name)
    super(name)
  end
end
