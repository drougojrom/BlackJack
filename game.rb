require_relative 'Models/player.rb'
require_relative 'Models/dealer.rb'
require_relative 'Models/card.rb'
require_relative 'Models/deck.rb'

class Game

  DEALER_STOP = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck

  def initialize(player, dealer, deck)
    @player = player
    @dealer = dealer
    @deck = deck
  end

  def play
    result = game_result
    dealer.bank -= result
    player.bank += result

    loop do
      puts 'Do you want to play again? y/n'
      continue = gets.chomp
      case continue
      when 'y'
        player.hand = []
        dealer.hand = []
        result = game_result
        dealer.bank -= result
        player.bank += result
      when 'n'
        break
      else
        puts 'Not a valid value'
      end
    end
  end

  def game_result
    2.times do
      self.deck.give_card(player)
      self.deck.give_card(dealer, false)
    end

    dealer.hand.last.show
    player_total = player.calculate_total
    dealer_total = dealer.calculate_total
    check_for_blackjack(player, dealer)
    player.display_hand
    if player.bank > 0 && dealer.bank > 0
      puts 'Take another card or skip? T/S'
      take_skip = gets.chomp.downcase
      while take_skip != 's' do
        if take_skip == 't'
          self.deck.give_card(player)
          player_total = player.calculate_total
          if player.lost?
            display_cards(player, dealer)
            puts "Sorry, you've lost your 10$"
            return -10
          end
        elsif take_skip != 's'
          puts 'Select take or skip: t/s'
        end
        player.display_hand
        puts 'Take another card or skip? T/S'
        take_skip = gets.chomp
      end

      dealer.hand.first.show

      while dealer_total < DEALER_STOP do
        self.deck.give_card(dealer)
        dealer_total = dealer.calculate_total
        if dealer_total > BLACKJACK
          display_cards(player, dealer)
          puts "Nice! I've just lost. You won 10$, #{player.name}!"
          return 10
        end
      end

      display_cards(player, dealer)

      if player_total > dealer_total
        puts "Nice, you've won!"
        return 10
      elsif dealer_total > player_total
        puts "Sorry, you've lost!"
        return -10
      else
        puts "It's a tie!"
      end
    else
      if player.bank == 0 
        puts "You don't have enough money to play"
      end
      if delaer.bank == 0 
        puts "Sorry, I'm out"
      end
      break
    end
  end

private

  def check_for_blackjack(player, dealer)
    if player.blackjack?
      player.display_hand
      dealer.display_hand
      puts "Congratulations, #{player.name}! You've earned 10$!"
      return 10
    end
    if dealer.blackjack?
      dealer.hand.first.show
      player.display_hand
      dealer.display_hand
      puts "Sorry, #{player.name}, you've lost your 10$."
      return -10
    end
  end

  def display_cards(player, dealer)
    puts 'Your cards: '
    player.display_hand
    puts 'My cards: '
    dealer.display_hand
  end
end
