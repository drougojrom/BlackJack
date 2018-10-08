require_relative '../models/player.rb'
require_relative '../models/dealer.rb'
require_relative '../models/card.rb'
require_relative '../models/deck.rb'
require_relative '../views/game_interface.rb'
require_relative '../modules/round.rb'

class GameController

  include Round

  DEALER_STOP = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck

  def initialize(player)
    @player = player
    @dealer = Dealer.new 'Dealer'
  end

  def start
    reset
    loop do
      display_cards
      GameInterface.display_total(player.total)
      choice = GameInterface.player_choice(player_choice)
      player_turn(choice)
      break if player_choice == :open
      dealer_turn unless dealer.choice == :card_taken
      break unless player_choice == :pass
    end
    result(name, determine_winner)
    return if player.bank == 0 || dealer.bank == 0  
    GameInterface.players_stats(player, dealer)
    start if GameInterface.restart_game?
  end

private

  def name
    player.name
  end

  def player_choice
    player.choice
  end

  def display_cards(show = nil)
    GameInterface.display_cards(player)
    GameInterface.display_cards(dealer, show)
  end

  def display_total
    GameInterface.display_total(player.total, dealer.total)
  end

  def player_turn(choice)
    player.update_choice(choice)
    case player_choice
    when :take_card
      deck.give_card(player)
      player.calculate_total
      if player.lost?
        player.update_choice(3)
        return
      end
    else
      return
    end
  end

  def dealer_turn
    if dealer.calculate_total < DEALER_STOP && dealer.hand.length < 3
      dealer.update_choice(1)
      deck.give_card(dealer)
      dealer.calculate_total
    end
  end
end
