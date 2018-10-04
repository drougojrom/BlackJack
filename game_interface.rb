class GameInterface

  def self.start_game?(player, dealer)
    puts 'Do you want to play? y/n'
    continue = gets.chomp
    puts "#{player.name} has #{player.bank}$"
    puts "Dealer has #{dealer.bank}$"
    case continue
    when 'y'
      deck = Deck.new
      player.hand = []
      dealer.hand = []
      player_total = 0
      dealer_total = 0
      {dealer: dealer,
       player: player,
       deck: deck,
       player_total: player_total,
       dealer_total: dealer_total}
    when 'n'
      return nil
    else
      puts 'not a valid value'
    end
  end

  def self.first_turn
    puts 'Take another card or skip? T/S'
    take_skip = gets.chomp.downcase
  end

  def self.display_cards(player, dealer)
    puts 'Your cards: '
    player.display_hand
    puts ''
    puts 'My cards: '
    dealer.display_hand
  end

  def self.display_result(player_name, result)
    case result
    when true
      puts "Nice! I've just lost. You won 10$, #{player_name}!"
    when false
      puts "Sorry, you've lost your 10$"
    else
      puts "It's a tie!"
    end
  end

  def self.show_error
    puts 'Select take or skip'
  end
end
