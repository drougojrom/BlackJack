class Dealer
  attr_accessor :name, :hand, :bank

  def initialize(name)
    @name = name
    @hand = []
    @bank = 100
  end

  def display_hand(show = nil)
    puts ''
    puts "#{self.name} has the following cards: "
    if name != 'Dealer' || show
      @hand.each do |card|
        puts card.open_card
      end
    else 
      puts "Dealer's card: "
      @hand.each do |card|
        puts '*'
      end
    end
  end

  def calculate_total
    total = 0
    ace_count = 0
    @hand.each do |card|
      total += card.value
      ace_count += 1 if card.value == 11
    end
    ace_count.times do
      total -= 10 if total > Game::BLACKJACK
    end
    total
  end

  def blackjack?
    calculate_total == Game::BLACKJACK
  end

  def lost?
    calculate_total > Game::BLACKJACK
  end
end
