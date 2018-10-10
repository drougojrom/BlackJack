class Round

  DEALER_STOP = 17

  attr_accessor :deck, :bank, :finished
  attr_reader :player, :dealer, :winner

  def initialize(player, dealer, bank)
    @player = player
    @dealer = dealer
    @bank = bank
    @finished = false
    restart
  end

  def restart
    player.bank -= 10
    dealer.bank -= 10
    @bank = 20
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

  def first_turn(choice)
    player_turn(choice)
    determine_winner if @finished
    dealer_turn
    determine_winner if @finished
  end

  def second_turn(choice)
    player_turn(choice)
    determine_winner
  end

  def finished?
    @finished
  end

private

  attr_writer :player, :dealer, :winner

  def player_turn(choice)
    case choice
    when 1
      deck.give_card(player)
      player.calculate_total
      if player.lost?
        @finished = true
      end
    when 2
      player.skipped = true
    when 3
      @finished = true
    end
  end

  def dealer_turn
    if dealer.calculate_total < DEALER_STOP && dealer.hand.length < 3
      deck.give_card(dealer)
      dealer.calculate_total
    end
    @finished = true if dealer.lost? || player.hand.length == 3
  end

  def determine_winner
    if player.total == dealer.total
      player.bank += bank / 2
      dealer.bank += bank / 2
      @winner = :draw
    elsif player.blackjack? || dealer.lost?
      player.bank += bank
      @winner = :player
    elsif dealer.blackjack? || player.lost?
      dealer.bank += bank
      @winner = :dealer
    elsif player.total > dealer.total
      player.bank += bank
      @winner = :player
    elsif player.total < dealer.total
      dealer.bank += bank
      @winner = :dealer
    end
  end
end
