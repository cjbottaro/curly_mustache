module CurlyMustache
  module Serialization
    
    def self.included(mod)
      mod.class_eval do
        class_inheritable_accessor :serializer
      end
      mod.serializer = Serializer.new
    end
    
    class Serializer
      
      def initialize
        @definitions = {}
      end
      
      def in(class_name = nil, &block)
        define_for(:in, class_name, &block)
      end
      
      def out(class_name = nil, &block)
        define_for(:out, class_name, &block)
      end
      
      def run_in(value)
        run_for(:in, value)
      end
      
      def run_out(value)
        run_for(:out, value)
      end
      
      def ==(other)
        @definitions == other.instance_variable_get("@definitions")
      end
      
      def dup
        returning(self.class.new) do |new_serializer|
          new_serializer.instance_variable_set("@definitions", @definitions.dup)
        end
      end
      
    private
      
      def define_for(direction, class_name, &block)
        @definitions[direction] = { :class_name => class_name, :block => block }
      end
      
      def run_for(direction, value)
        definition = @definitions[direction] or return value
        if definition[:instance]
          definition[:instance].send(direction, value)
        elsif definition[:class_name]
          definition[:instance] = definition[:class_name].to_s.camelize.constantize.new
          definition[:instance].send(direction, value)
        elsif definition[:block]
          definition[:block].call(value)
        else
          raise ArgumentError, "no class or block provided for serialization"
        end
      end
      
    end
    
  end
end