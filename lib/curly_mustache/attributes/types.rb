module CurlyMustache
  module Attributes
    module Types
      
      def self.definitions
        @definitions ||= {}
      end
      
      def self.clear
        @definitions = {}
      end
      
      def self.define(name, &block)
        definitions[name.to_s] = OpenStruct.new(:name => name, :caster => block)
      end
      
      def self.[](name)
        name = name.to_s
        raise TypeError, "type #{name} is not defined" unless definitions.has_key?(name)
        definitions[name]
      end
      
    end
  end
end