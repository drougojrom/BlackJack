require_relative 'Models/player.rb'
require_relative 'Models/dealer.rb'
require_relative 'Models/card.rb'
require_relative 'Models/deck.rb'
require_relative 'game_interface.rb'

class Game

  DEALER_STOP = 17
  BLACKJACK = 21

  attr_accessor :player, :dealer, :deck, :player_total, :dealer_total

  def initialize(player, dealer, deck)
    @player = player
    @dealer = dealer
  end

  def play
    loop do
      break if @player.bank == 0 || @dealer.bank == 0
      break unless restarted_game = GameInterface.start_game?(@player, @dealer)
      @dealer.hand = []
      @player.hand = []
      @deck = Deck.new
      @player_total = 0
      @dealer_total = 0
      result = game_result
      @dealer.bank -= result
      @player.bank += result
    end
  end

private

  def game_result
    2.times do
      self.deck.give_card(@player)
      self.deck.give_card(@dealer, false)
    end

    @player_total = player.calculate_total
    @dealer_total = dealer.calculate_total

    loop do
      take_skip = GameInterface.first_turn
      handle_player_turn(take_skip)
    end

    if blackjack = check_for_blackjack
      handle_result(@player.name, blackjack)
    end

    handle_dealer_turn

    handle_end_game
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

  def handle_player_turn(take_skip)
    if take_skip == 't' && @player.hand.length == 2
      self.deck.give_card(@player)
      @player_total = @player.calculate_total
      if @player.lost?
        GameInterface.display_cards(@player, @dealer)
        return handle_result(@player.name, false)
      end
    elsif take_skip == 's'
      GameInterface.display_cards(@player)
    elsif take_skip == 'p'
    end
  end

  def handle_dealer_turn
    while @dealer_total < DEALER_STOP && @dealer.hand.length == 2 do
      self.deck.give_card(@dealer)
      @dealer_total = @dealer.calculate_total
      if dealer_total > BLACKJACK
        GameInterface.display_cards(@player, @dealer)
        return handle_result(@player.name, true)
      end
    end
  end
end
