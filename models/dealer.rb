class Dealer

  attr_accessor :name, :hand, :bank, :total

  def initialize(name)
    @name = name
    @hand = []
    @bank = 100
    @total = 0
  end

  def calculate_total
    total = 0
    ace_count = 0
    @hand.each do |card|
      total += card.value
      ace_count += 1 if card.value == 11
    end
    ace_count.times do
      total -= 10 if total > GameController::BLACKJACK
    end
    @total = total
  end

  def blackjack?
    calculate_total == GameController::BLACKJACK
  end

  def lost?
    calculate_total > GameController::BLACKJACK
  end
end
