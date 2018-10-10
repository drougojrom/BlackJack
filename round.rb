module Round
  def determine_winner
    player_result = nil
    if player.total == dealer.total
      player_result = nil
    elsif player.blackjack? || dealer.lost?
      player_result = true
    elsif dealer.blackjack? || player.lost?
      player_result = false
    elsif player.total > dealer.total
      player_result = true
    elsif player.total < dealer.total
      player_result = false
    end
    player_result
  end

  def result(name, win)
    display_cards(true)
    display_total
    GameInterface.display_result(name, win)
    unless win.nil?
      bank_value = win ? 10 : -10
      dealer.bank -= bank_value
      player.bank += bank_value
    end
    return if player.bank == 0 || dealer.bank == 0
    GameInterface.players_stats(player, dealer)
  end

  def reset
    dealer.hand = []
    player.hand = []
    @deck = Deck.new
    2.times do
      deck.give_card(player)
      deck.give_card(dealer, false)
    end
    player.calculate_total
    dealer.calculate_total
    @finished = false
  end
end
