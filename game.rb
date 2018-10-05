require_relative 'models/player.rb'
require_relative 'models/dealer.rb'
require_relative 'models/card.rb'
require_relative 'models/deck.rb'
require_relative 'game_interface.rb'

class Game

  DEALER_STOP = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck

  def initialize(player)
    @player = player
    @dealer = Dealer.new 'Dealer'
    @deck = Deck.new
  end

  def play
    loop do
      break if @player.bank == 0 || @dealer.bank == 0
      break unless GameInterface.start_game?(@player, @dealer)
      restart_game
      if result = game_result
        @dealer.bank -= result
        @player.bank += result
      end
    end
  end

private

  def restart_game
    @dealer.hand = []
    @player.hand = []
    @deck = Deck.new
    2.times do
      @deck.give_card(@player)
      @deck.give_card(@dealer, false)
    end
  end

  def game_result
    display_cards
    GameInterface.display_total(@player.calculate_total)
    player_choice = GameInterface.first_turn
    handle_player_turn(player_choice)
  end

  def display_cards(show = nil)
    @player.display_hand
    @dealer.display_hand(show)
  end

  def display_total
    GameInterface.display_total(@player.calculate_total, @dealer.calculate_total)
  end

  def determine_winner
    if @player.blackjack? || @dealer.lost?
      handle_result(@player.name, true)
    elsif @dealer.blackjack? || @player.lost?
      handle_result(@player.name, false)
    elsif @player.calculate_total > @dealer.calculate_total
      handle_result(@player.name, true)
    elsif @player.calculate_total < @dealer.calculate_total
      handle_result(@player.name, false)
    else
      handle_result(@player.name, nil)
      GameInterface.display_result(@player.name)
    end
  end

  def handle_result(name, win)
    display_cards(true)
    display_total
    unless win.nil?
      GameInterface.display_result(name, win)
      return win ? 10 : -10
    end
  end

  def handle_player_turn(player_choice)
    case player_choice
    when 1
      @deck.give_card(@player)
      determine_winner
    when 2
      handle_dealer_turn
    when 3
      display_cards
      determine_winner
    end
  end

  def handle_dealer_turn
    if @dealer.calculate_total < DEALER_STOP && @dealer.hand.length < 3
      @deck.give_card(@dealer)
    end
    determine_winner
  end
end
