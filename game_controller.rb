require_relative './models/player.rb'
require_relative './models/dealer.rb'
require_relative './models/card.rb'
require_relative './models/deck.rb'
require_relative 'game_interface.rb'
require_relative 'round.rb'

class GameController

  include Round

  DEALER_STOP = 17

  attr_accessor :player, :dealer, :deck, :finished

  def initialize(player)
    @player = player
    @dealer = Dealer.new 'Dealer'
    @finished = false
    reset
  end

  def start
    loop do
      player_turn
      if @finished
        result(determine_winner)
      else
        dealer_turn
        result(determine_winner) if @finished
        player_turn(2) unless @finished
        result(determine_winner)
      end
      GameInterface.display_result(name, determine_winner)
      GameInterface.players_stats(player, dealer)
      break if player.bank == 0 || dealer.bank == 0
      break unless GameInterface.restart_game?
      reset
    end
  end

  private

  def name
    player.name
  end

  def display_cards(show = nil)
    GameInterface.display_cards(player)
    GameInterface.display_cards(dealer, show)
  end

  def display_total
    GameInterface.display_total(player.total, dealer.total)
  end

  def player_turn(choice = nil)
    display_cards
    GameInterface.display_total(player.total)
    choice = GameInterface.player_choice(choice)
    case choice
    when 1
      deck.give_card(player)
      player.calculate_total
      if player.lost?
        @finished = true
      end
    when 2
      return
    when 3
      @finished = true
    end
  end

  def dealer_turn
    if dealer.calculate_total < DEALER_STOP && dealer.hand.length < 3
      deck.give_card(dealer)
      dealer.calculate_total
    end
    @finished = true if dealer.lost? || player.hand.length == 3
  end
end
