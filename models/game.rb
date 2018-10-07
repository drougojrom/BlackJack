require_relative './models/player.rb'
require_relative './models/dealer.rb'
require_relative './models/card.rb'
require_relative './models/deck.rb'
require_relative './views/game_interface.rb'
require_relative './modules/round.rb'

class Game

  include Round

  DEALER_STOP = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck

  def initialize(player)
    @player = player
    @dealer = Dealer.new 'Dealer'
  end

  def start
    loop do
      restart_game
      result
      break if @player.bank == 0 || @dealer.bank == 0      
      break unless GameInterface.restart_game?
      GameInterface.players_stats(@player, @dealer)
    end
  end

private

  def name
    @player.name
  end

  def state
    @player.state
  end

  def restart_game
    dealer.hand = []
    player.hand = []
    player.update_state(0)
    @deck = Deck.new
    2.times do
      @deck.give_card(@player)
      @deck.give_card(@dealer, false)
    end
  end

  def result
    loop do
      display_cards
      GameInterface.display_total(player.calculate_total)
      choice = GameInterface.player_choice(state)
      handle_player_turn(choice)
      break if state == :open
      handle_dealer_turn
      break unless state == :pass
    end
    handle_result(name, determine_winner)
  end

  def display_cards(show = nil)
    GameInterface.display_cards(player)
    GameInterface.display_cards(dealer, show)
  end

  def handle_player_turn(player_choice)
    player.update_state(player_choice)
    case state
    when :take_card
      @deck.give_card(player)
      if player.lost?
        handle_result(name, false) if player.lost?
        return
      end
    when :pass
      return
    when :open
      handle_result(name, determine_winner)
      return
    end
  end

  def display_total
    GameInterface.display_total(player.calculate_total, dealer.calculate_total)
  end

  def handle_dealer_turn
    if dealer.calculate_total < DEALER_STOP && dealer.hand.length < 3
      @deck.give_card(dealer)
    end
  end
end
