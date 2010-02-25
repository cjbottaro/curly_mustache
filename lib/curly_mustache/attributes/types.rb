module CurlyMustache
  module Attributes
    # <tt>CurlyMustache</tt> comes with 5 types predefined:  string, integer, float, time, boolean.
    # You can redefine any of them or add new type defintions.  To define a type is simply to define
    # how a value gets typecasted.
    #  CurlyMustache::Attributes::Types.define(:capitalized_string) do |value|
    #    value.capitalize
    #  end
    # Now if you have a user class...
    #  class User < CurlyMustache::Base
    #    attribute :name, :string
    #    attribute :title, :capitalized_string
    #  end
    # And you can see the new type in action...
    #  user = User.new
    #  user.name = "chris"
    #  user.title = "mr"
    #  user.name                  # => "chris"
    #  user.title                 # => "Mr"
    #  user.title = 123           # NoMethodError: undefined method `capitalize' for 123:Fixnum
    module Types
      
      # Gets a hash of all type defintions.  The keys will be the type names and they will always be strings.
      def self.definitions
        @definitions ||= {}
      end
      
      # Clear all type defintions (including the defaults).
      def self.clear
        @definitions = {}
      end
      
      # Define a type.  The block takes a single argument which is the raw value and should return
      # the typecasted value.
      def self.define(name, &block)
        definitions[name.to_s] = OpenStruct.new(:name => name, :caster => block)
      end
      
      # Similar to <tt>CurlyMustache::Attributes::Types.defintions[name]</tt> but is indifferent to
      # whether +name+ is a string or symbol and will raise an exception if +name+ is not a defined.
      def self.[](name)
        name = name.to_s
        raise TypeError, "type #{name} is not defined" unless definitions.has_key?(name)
        definitions[name]
      end
      
    end
  end
end