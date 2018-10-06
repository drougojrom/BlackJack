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
  end

  def play
    loop do
      break if @player.bank == 0 || @dealer.bank == 0
      start_game = GameInterface.start_game?(@player, @dealer)
      case start_game
      when true
        restart_game
        if result = game_result
          @dealer.bank -= result
          @player.bank += result
        end
      when false
        break
      when nil
        next
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
    GameInterface.display_cards(@player)
    GameInterface.display_cards(@dealer, show)
  end

  def display_total
    GameInterface.display_total(@player.calculate_total, @dealer.calculate_total)
  end

  def determine_winner
    player_win = false
    if @player.blackjack? || @dealer.lost?
      player_win = true
    elsif @dealer.blackjack? || @player.lost?
      player_win = false
    elsif @player.calculate_total > @dealer.calculate_total
      player_win = true
    elsif @player.calculate_total < @dealer.calculate_total
       player_win = false
    else
      player_win = nil
    end
    handle_result(@player.name, player_win)
  end

  def handle_result(name, win)
    display_cards(true)
    display_total
    GameInterface.display_result(name, win)
    unless win.nil?
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
    else
      GameInterface.show_error('Not a valid choice, the game will abort')
    end
  end

  def handle_dealer_turn
    if @dealer.calculate_total < DEALER_STOP && @dealer.hand.length < 3
      @deck.give_card(@dealer)
    end
    determine_winner
  end
end
