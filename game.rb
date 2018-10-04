require_relative 'Models/player.rb'
require_relative 'Models/dealer.rb'
require_relative 'Models/card.rb'
require_relative 'Models/deck.rb'
require_relative 'game_interface.rb'

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
    @dealer.bank -= result
    @player.bank += result

    loop do
      if @player.bank > 0 && @dealer.bank > 0
        break unless restarted_game = GameInterface.start_game?(@player, @dealer)
        @dealer = restarted_game[:dealer]
        @player = restarted_game[:player]
        @deck = restarted_game[:deck]
        result = game_result
        @dealer.bank -= result
        @player.bank += result
      else
        break
      end
    end
  end

  private

  def game_result
    2.times do
      self.deck.give_card(@player)
      self.deck.give_card(@dealer, false)
    end

    player_total = player.calculate_total
    dealer_total = dealer.calculate_total

    @player.display_hand

    take_skip = GameInterface.first_turn

    if take_skip == 't' && @player.hand.length == 2
      self.deck.give_card(@player)
      player_total = @player.calculate_total
      if @player.lost?
        GameInterface.display_cards(@player, @dealer)
        GameInterface.display_result(@player.name, false)
        return -10
      end
    elsif take_skip != 's'
      GameInterface.show_error
      return 0
    end

    check_for_blackjack

    while dealer_total < DEALER_STOP && @dealer.hand.length == 2 do
      self.deck.give_card(@dealer)
      dealer_total = @dealer.calculate_total
      if dealer_total > BLACKJACK
        GameInterface.display_cards(@player, @dealer)
        GameInterface.display_result(@player.name, true)
        return 10
      end
    end

    GameInterface.display_cards(@player, @dealer)

    if player_total > dealer_total
      GameInterface.display_result(@player.name, true)
      return 10
    elsif dealer_total > player_total
      GameInterface.display_result(@player.name, false)
      return -10
    else
      GameInterface.display_result(@player.name, nil)
    end
  end

  def check_for_blackjack
    if @player.blackjack?
      @player.display_hand
      @dealer.display_hand
      GameInterface.display_result(@player.name, true)
      return 10
    end
    if @dealer.blackjack?
      @player.display_hand
      @dealer.dispay_hand
      GameInterface.display_result(@player.name, false)
      return -10
    end
  end
end
