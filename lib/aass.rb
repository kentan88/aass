# require "aa ss/version"

module AASS
  def self.included(base)
    base.extend(ClassMethods)

    base.class_eval do
      def next_state
        states = self.class.aass.states
        current_state = self.send(states[:column]).to_sym

        if states.keys.include?(current_state)
          possible_states = states[current_state]
          next_state_hash = possible_states.detect { |hash| self.send(hash[:if]) }
          self.status = next_state_hash[:to].to_s if next_state_hash
        end
      end
    end
  end

  module ClassMethods
    def aass(opts={}, &block)
      @aass ||= AASS::Base.new(self, opts)
      @aass.instance_eval(&block) if block
      @aass
    end
  end

  class Base
    attr_accessor :klass, :states, :state, :column
    def initialize(klass, opts = {})
      @column = opts[:column] || :state
      @klass = klass
      @states = {}
    end

    def from(state, &block)
      @state = state
      @states[@state] ||= []
      self.instance_eval(&block) if block
    end

    def to(state, opts = {})
      @states[:column] = @column
      @states[@state] << opts.merge(to: state)
    end
  end
end
