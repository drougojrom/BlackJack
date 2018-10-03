class Card

  attr_accessor :value

  def initialize(face, suit, hidden)
    @face = face
    @suit = suit
    @hidden = hidden
    @value = 0
  end

  def open_card
    "#{@face} #{@suit}" 
  end

  def show
    @hidden = !@hidden
  end

  def value
    case @face
    when "J", "Q", "K"
      @value = 10
    when 1
      @value = 11
    else
      @value = @face
    end
  end
end
