require './game.rb'

puts "Welcome to Blackjack!"
puts "I'm going to be the dealer, and my name is Joe."
puts "If you don't mind me asking, what's your name?"
name = gets.chomp
puts "Nice to meet you, #{name}! Let's get started."
binding.pry
player = Player.new name
dealer = Dealer.new("Dealer")
deck = Deck.new

game = Game.new(player, dealer, deck)
game.play
