require_relative 'dealer.rb'
require 'pry'

class Player < Dealer

  attr_accessor :skipped

  def initialize(name)
    @skipped = false
    super(name)
  end
end
