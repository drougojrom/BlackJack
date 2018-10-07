class GameInterface

  def self.players_stats(player, dealer)
    puts "#{player.name} has #{player.bank}$"
    puts "Dealer has #{dealer.bank}$"
  end

  def self.restart_game?
    puts 'Do you want to play again? Y - 1; N - 2'
    choice = gets.to_i
    case choice
    when 1
      true
    when 2
      false
    else
      self.show_error 'not a valid value'
      nil
    end
  end

  def self.player_choice(state = nil)
    puts 'Select one of the options'
    puts 'Take - 1'
    puts 'Pass - 2' unless state == :pass
    puts 'Open - 3'
    take_skip = gets.to_i
    case take_skip
    when 1, 3
      take_skip
    when 2
      if state != :pass
        take_skip
      else
        self.show_error 'Not valid'
        self.player_choice(:pass)      
      end
    else
      self.show_error 'Not valid choice, try again'
      self.player_choice(state)
    end
  end

  def self.display_cards(player, show = nil)
    puts ''
    name = player.name
    hand = player.hand
    puts "#{name} has the following cards: "
    if name != 'Dealer' || show
      hand.each do |card|
        puts card.open_card
      end
    else 
      puts "Dealer's card: "
      hand.each do |card|
        puts '*'
      end
    end
  end

  def self.display_result(player_name, result = nil)
    case result
    when true
      puts "Nice! I've just lost. You won 10$, #{player_name}!"
    when false
      puts "Sorry, you've lost your 10$"
    else
      puts "It's a tie!"
    end
  end

  def self.display_total(player_total, dealer_total = nil)
    puts "Player's total is #{player_total}"
    puts ''
    puts "Dealer's total is #{dealer_total}" unless dealer_total.nil?
  end

  def self.show_error(error)
    puts error
  end
end
