require './game.rb'

puts "Welcome to Blackjack!"
puts "I'm going to be the dealer, and my name is Rom."
puts "If you don't mind me asking, what's your name?"
name = gets.chomp
puts "Nice to meet you, #{name}! Let's get started."
player = Player.new name
dealer = Dealer.new("Rom")
deck = Deck.new

game = Game.new(player, dealer, deck)
game.play
