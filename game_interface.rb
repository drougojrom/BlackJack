class GameInterface
  def self.start_game?(player, dealer)
    puts 'Do you want to play? y/n'
    continue = gets.chomp
    puts "#{player.name} has #{player.bank}$"
    puts "Dealer has #{dealer.bank}$"
    case continue
    when 'y'
      if player.bank > 0 && dealer.bank > 0
        deck = Deck.new
        player.hand = []
        dealer.hand = []
        {dealer: dealer, player: player, deck: deck}
      end
    when 'n'
      return nil
    else
      puts 'not a valid value'
    end
  end

  def self.result(player, dealer)

  end
end
