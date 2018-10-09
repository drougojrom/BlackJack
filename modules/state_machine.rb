module StateMachine
  attr_accessor :choice

  def update_choice(choice)
    updated_choice = StateMachine::CHOICES[choice]
    @choice = updated_choice unless updated_choice.nil?
  end

private
  CHOICES = [:nd, :take_card, :pass, :open]
end
