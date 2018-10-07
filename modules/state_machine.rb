module StateMachine
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    attr_accessor :state
    def update_state(state)
      updated_state = StateMachine::STATES[state]
      @state = updated_state unless updated_state.nil?
    end
  end

private
  STATES = [:nd, :take_card, :pass, :open]
end
