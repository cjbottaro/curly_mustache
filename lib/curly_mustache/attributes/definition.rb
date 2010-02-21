module CurlyMustache
  module Attributes
    class Definition
      attr_reader :name, :type
      
      def initialize(name, type, options = {})
        @options = options.symbolize_keys.reverse_merge :default => nil,
                                                        :allow_nil => true
        @name = name.to_sym
        @type = type.to_sym
        @caster = Types[type].caster
      end
      
      def cast(value)
        if value.nil? and @options[:allow_nil]
          nil
        else
          @caster.call(value)
        end
      end
      
    end
  end
end