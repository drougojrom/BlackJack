class GameInterface

  attr_accessor :player, :dealer

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
  end

  def stats
    puts "#{player.name} has #{player.bank}$"
    puts "Dealer has #{dealer.bank}$"
  end

  def restart_game?
    puts 'Do you want to play again? Y - 1; N - 2'
    choice = gets.to_i
    case choice
    when 1
      true
    when 2
      false
    else
      show_error 'not a valid value'
      restart_game?
    end
  end

  def player_choice(skipped = false)
    puts 'Select one of the options'
    puts 'Take - 1'
    puts 'Pass - 2' unless skipped
    puts 'Open - 3'
    turn = gets.to_i
    case turn
    when 1, 3
      turn
    when 2
      unless skipped
        turn
      else
        show_error 'Not valid'
        nil
      end
    else
      show_error 'Not valid choice, try again'
      nil
    end
  end

  def player_cards
    puts ''
    name = player.name
    hand = player.hand
    puts "#{name} has the following cards: "
    hand.each do |card|
      puts card.open_card
    end
  end

  def dealer_cards(show = false)
    puts ''
    hand = dealer.hand
    puts 'Dealer has the following cards: '
    if show
      hand.each do |card|
        puts card.open_card
      end
    else
      hand.each do |card|
        puts '*'
      end
    end
  end

  def result(result = nil)
    name = player.name
    case result
    when :player
      puts "Nice! I've just lost. You won 10$, #{name}!"
    when :dealer
      puts "Sorry, you've lost your 10$"
    else
      puts "It's a tie!"
    end
  end

  def total(show = false)
    puts "Player's total is #{player.total}"
    puts ''
    puts "Dealer's total is #{dealer.total}" if show
  end

  def show_error(error)
    puts error
  end
end
