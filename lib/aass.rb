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
    attr_accessor :klass, :states
    def initialize(klass, opts = {})
      @klass = klass
      @states = {}
    end

    def set(opts)
      @states[opts[:from]] ||= []
      @states[opts[:from]] << { to: opts[:to], if: opts[:if] }
    end
  end
end
