module Round
  def determine_winner
     player_result = nil
    if player.blackjack? || dealer.lost?
      player_result = true
    elsif dealer.blackjack? || player.lost?
      player_result = false
    elsif player.calculate_total > dealer.calculate_total
      player_result = true
    elsif player.calculate_total < dealer.calculate_total
      player_result = false
    end
    player_result
  end

  def handle_result(name, win)
    display_cards(true)
    display_total
    GameInterface.display_result(name, win)
    unless win.nil?
      bank_value = win ? 10 : -10
      dealer.bank -= bank_value
      player.bank += bank_value
    end
  end
end
