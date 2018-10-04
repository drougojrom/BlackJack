class GameInterface

  def self.start_game?(player, dealer)
    puts "#{player.name} has #{player.bank}$"
    puts "Dealer has #{dealer.bank}$"
    puts 'Do you want to play? Y - 1; N - 2'
    choice = gets.to_i
    case choice
    when 1
      true
    when 2
      false
    else
      puts 'not a valid value'
    end
  end

  def self.first_turn
    puts 'Take another card, pass or show hand? T/P/S'
    take_skip = gets.chomp.downcase
    take_skip
  end

  def self.display_cards(player, dealer = nil)
    puts 'Your cards: '
    player.display_hand
    puts ''
    if dealer
      puts 'My cards: '
      dealer.display_hand
    end
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
