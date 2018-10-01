class Card

  def initialize(face, suit, hidden)
    @face = face
    @suit = suit
    @hidden = hidden
  end

  def open_card
    !@hidden ? "#{@face} #{@suit} : the card was opened"
  end

  def show
    @hidden = !@hidden
  end

  def card_value
    case @face
    when "J", "Q", "K"
      value = 10
    when 1
      value = 11
    else
      value = @face
    end
  end
end
