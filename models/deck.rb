class Deck
 def initialize
   @cards = []
   add_pack
 end

 def add_pack
   deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]
   suits = ["H", "D", "C", "S"]
   shuffled_deck = (deck.product(suits)).shuffle
   shuffled_deck.each do |cards|
     @cards.push Card.new(cards[0], cards[1], true)
   end
 end

 def give_card(player, show=true)
   card = @cards.pop
   card.show if show
   player.hand.push card
 end
end
