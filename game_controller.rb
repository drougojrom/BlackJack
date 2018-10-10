require_relative './models/player.rb'
require_relative './models/dealer.rb'
require_relative './models/card.rb'
require_relative './models/deck.rb'
require_relative 'game_interface.rb'
require_relative 'round.rb'

class GameController

  attr_accessor :player, :dealer, :round, :interface

  def initialize(player, dealer, interface)
    @player = player
    @dealer = dealer
    @interface = interface
  end

  def start
    @round = Round.new player, dealer, 20
    loop do
      player_cards_total
      next unless choice = interface.player_choice
      round.first_turn(choice)
      if round.finished?
        open_cards
        interface.result(round.winner)
      else
        player_cards_total
        interface.dealer_cards        
        choice = interface.player_choice(player.skipped)   
        round.second_turn(choice)
        open_cards
        interface.result(round.winner)
      end
      break unless interface.restart_game?
      round.restart
    end
  end

private 

  def open_cards
    interface.player_cards
    interface.dealer_cards(true)
    interface.total(true)
    interface.stats
  end

  def player_cards_total
    interface.player_cards
    interface.total(false)
  end
end
