# require "aa ss/version"

module AASS
  def self.included(base)
    base.extend(ClassMethods)

    base.class_eval do
      def next_state
        states = self.class.aass.states
        current_state = self.status.to_sym

        if states.keys.include?(current_state)
          possible_states = states[current_state]
          next_state_hash = possible_states.detect { |hash| self.send(hash[:if]) }
          self.status = next_state_hash[:to].to_s if next_state_hash
        end
      end
    end
  end

  module ClassMethods
    def aass(options={}, &block)
      @aass ||= AASS::Base.new(self, options)
      @aass.instance_eval(&block) if block
      @aass
    end
  end

  class Base
    attr_accessor :klass, :states, :state
    def initialize(klass, opts = {})
      @klass = klass
      @states = {}
    end

    def from(state, &block)
      @state = state
      @states[@state] ||= []
      self.instance_eval(&block) if block
    end

    def to(state, opts = {})
      @states[@state] << opts.merge(to: state)
    end
  end
end
