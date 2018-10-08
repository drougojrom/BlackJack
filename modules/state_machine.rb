module StateMachine
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    attr_accessor :choice
    def update_choice(choice)
      updated_choice = StateMachine::CHOICES[choice]
      @choice = updated_choice unless updated_choice.nil?
    end
  end

private
  CHOICES = [:nd, :take_card, :pass, :open]
end
