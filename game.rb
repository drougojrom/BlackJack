require_relative 'Models/player.rb'
require_relative 'Models/dealer.rb'
require_relative 'Models/card.rb'
require_relative 'Models/deck.rb'
require_relative 'game_interface.rb'

class Game

  DEALER_STOP = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck, :player_total, :dealer_total

  def initialize(player)
    @player = player
    @dealer = Dealer.new 'Dealer'
  end

  def play
    loop do
      break if @player.bank == 0 || @dealer.bank == 0
      break unless GameInterface.start_game?(@player, @dealer)
      restart_game
      result = game_result
      @dealer.bank -= result
      @player.bank += result
    end
  end

  private

  def restart_game
    @dealer.hand = []
    @player.hand = []
    @deck = Deck.new
    @player_total = 0
    @dealer_total = 0
  end

  def game_result
    2.times do
      @deck.give_card(@player)
      @deck.give_card(@dealer, false)
    end

    @player.display_hand

    @player_total = @player.calculate_total
    @dealer_total = @dealer.calculate_total

    GameInterface.display_total(@player_total)

    player_choice = GameInterface.first_turn
    handle_player_turn(player_choice)

    if blackjack = check_for_blackjack
      handle_result(@player.name, blackjack)
    end

    handle_dealer_turn

    handle_end_game
  end

  def display_cards
    @player.display_hand
    @dealer.display_hand
  end

  def display_total
    GameInterface.display_total(@player_total, @dealer_total)
  end

  def handle_end_game
    if @player_total > @dealer_total
      return handle_result(@player.name, true)
    elsif dealer_total > player_total
      return handle_result(@player.name, false)
    else
      GameInterface.display_result(@player.name, nil)
    end
  end

  def handle_result(name, win)
    display_cards
    display_total
    GameInterface.display_result(name, win)
    return win ? 10 : -10
  end

  def check_for_blackjack
    if @player.blackjack?
      return true
    elsif @dealer.blackjack?
      return false
    else
      return nil
    end
  end

  def handle_player_turn(player_choice)
    case player_choice
    when 1
      @deck.give_card(@player)
      @player_total = @player.calculate_total
      if @player.lost?
        GameInterface.display_cards(@player, @dealer)
        handle_result(@player.name, false)
      end
    when 2
      handle_dealer_turn
    when 3
      display_cards
    end
  end

  def handle_dealer_turn
    while @dealer_total < DEALER_STOP && @dealer.hand.length == 2 do
      @deck.give_card(@dealer)
      @dealer_total = @dealer.calculate_total
      if dealer_total > BLACKJACK
        GameInterface.display_cards(@player, @dealer)
        handle_result(@player.name, true)
      end
    end
  end
end
