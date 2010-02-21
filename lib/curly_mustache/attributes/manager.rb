require "curly_mustache/attributes/types"
require "curly_mustache/attributes/definition"

module CurlyMustache
  module Attributes
    class Manager
      attr_reader :definitions
      
      def initialize
        @definitions = {}
      end
      
      def define(klass, name, type, options = {})
        @definitions[name.to_s] = Definition.new(name, type, options)
        
        klass.class_eval <<-eval
          def #{name}; read_attribute(:#{name}); end
          def #{name}=(value); write_attribute(:#{name}, value); end
        eval
        
        # This is so ghetto, but these are the hoops we have to jump through
        # to get ActiveModel::Dirty working with inheritance.
        klass.undefine_attribute_methods
        klass.define_attribute_methods(@definitions.keys.collect(&:to_sym))
      end
      
      def [](name)
        name = name.to_s
        raise AttributeNotDefinedError, "#{name} is not defined" unless @definitions.has_key?(name)
        @definitions[name]
      end
      
      def dup
        returning(self.class.new) do |new_manager|
          new_manager.instance_variable_set("@definitions", @definitions.dup)
        end
      end
      
    end
  end
end