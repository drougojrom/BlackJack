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
      GameInterface.display_total(player.calculate_total)
      choice = GameInterface.player_choice(state)
      player_turn(choice)
      break if state == :open
      dealer_turn unless dealer.state == :card_taken
      break unless state == :pass
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

  def state
    player.state
  end

  def display_cards(show = nil)
    GameInterface.display_cards(player)
    GameInterface.display_cards(dealer, show)
  end

  def display_total
    GameInterface.display_total(player.calculate_total, dealer.calculate_total)
  end

  def player_turn(player_choice)
    player.update_state(player_choice)
    case state
    when :take_card
      deck.give_card(player)
      if player.lost?
        player.update_state(3)
        return
      end
    else
      return
    end
  end

  def dealer_turn
    if dealer.calculate_total < DEALER_STOP && dealer.hand.length < 3
      dealer.update_state(1)
      deck.give_card(dealer)
    end
  end
end
