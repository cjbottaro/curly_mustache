module CurlyMustache
  module Attributes
    class Definitions < Hash
      def [](key)
        key = key.to_sym
        raise AttributeNotDefinedError, "unexpected attribute: #{key}" unless has_key?(key)
        super(key)
      end
    end
  end
end