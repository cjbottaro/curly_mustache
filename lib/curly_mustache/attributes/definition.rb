module CurlyMustache
  module Attributes
    class Definition
      attr_reader :name, :type
      
      def initialize(name, type, options = {})
        @options = options.symbolize_keys.reverse_merge :default => nil
        @name = name.to_sym
        @type = type.to_sym
        @caster = Types[type].caster
      end
      
      def cast(value)
        @caster.call(value)
      end
      
    end
  end
end