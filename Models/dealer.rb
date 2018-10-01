class Dealer
  attr_accessor :name, :hand, :tally

  def initalize(name)
    @name = name
    @hand = []
    @tally = 0
  end

  def show_hand
    puts "#{self.name} has the following cards: "
    @hand.each do |card|
      puts card.show
    end
  end
end
