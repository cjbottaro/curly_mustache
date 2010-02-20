require "curly_mustache/attributes/types"
require "curly_mustache/attributes/definition"

module CurlyMustache
  module Attributes
    class Manager
      attr_reader :definitions
      
      def initialize(klass)
        @class = klass
        @definitions = {}
      end
      
      def define(name, type, options = {})
        @definitions[name.to_s] = Definition.new(name, type, options)
        @class.class_eval <<-eval
          def #{name}; read_attribute(:#{name}); end
          def #{name}=(value); write_attribute(:#{name}, value); end
        eval
      end
      
      def [](name)
        name = name.to_s
        raise AttributeNotDefinedError, "#{name} is not defined" unless @definitions.has_key?(name)
        @definitions[name]
      end
      
      def dup
        returning(self.class.new(@class)) do |new_manager|
          new_manager.instance_variable_set("@definitions", @definitions.dup)
        end
      end
      
    end
  end
end