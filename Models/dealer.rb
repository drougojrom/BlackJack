class Dealer
  attr_accessor :name, :hand, :tally, :bank

  def initalize(name)
    @name = name
    @hand = []
    @tally = 0
    @bank = 100
  end

  def show_hand
    puts "#{self.name} has the following cards: "
    @hand.each do |card|
      puts card.show
    end
  end

  def calculate_total
    total = 0
    ace_count = 0
    @hand.each do |card|
      total += card.value
      ace_count = += 1 if card.value == 11
    end
    ace_count.each do |card|
      total -= 10 if total > Game::BLACKJACK
    end
  end

  def blackjack?
    self.calculate_total == Game::BLACKJACK
  end

  def lost?
    self.calculate_total > Game::BLACKJACK
  end
end
