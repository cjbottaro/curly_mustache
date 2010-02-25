require "curly_mustache/adapters/abstract"

module CurlyMustache
  # Adapters are how CurlyMustache talks to various data stores.
  #
  # You define new adapters by subclassing CurlyMustache::Adapters::Abstract and then calling <tt>CurlyMustache::Adapters.register</tt>.
  # At a bare minimum, you need to implement +initialize+, +get+, +put+, +delete+.
  # 
  # Ex:
  #  class MyFunkyAdapter < CurlyMustache::Adapters::Abstract
  #  
  #    # config is the same hash that is passed to #establish_connection.
  #    def initialize(config)
  #      @client = FunkyDataStoreClient.new(config)
  #    end
  #  
  #    def get(key)
  #      @client.retrieve(key)
  #    end
  #  
  #    def put(key, value)
  #      @client.store(key, value)
  #    end
  #  
  #    def delete(key)
  #      @client.destroy(key)
  #    end
  #  end
  #  
  #  # Now we register the adapter so we can use it in #establish_connection.
  #  CurlyMustache::Adapters.register(MyFunkyAdapter)
  #  
  #  # We can see a list of registered adapters.
  #  CurlyMustache::Adapters.list # => { :my_funky_adapter => MyFunkyAdapter }
  #  
  #  # The hash passed to #establish_connection is passed as config to #initialize.
  #  CurlyMustache::Base.establish_connection :adapter => :my_funky_adapter, :server => "localhost", :option1 => "blah"
  module Adapters
    
    # Register an adapter class so it can be referenced by name by +establish_connection+.
    # If the class you are registering is <tt>MyModule::MyClass</tt> then the name it will be registered
    # under will simply be <tt>:my_class</tt>.
    def self.register(klass)
      @registered_adapters ||= {}
      @registered_adapters[klass.name.split("::").last.underscore.to_sym] = klass
    end
    
    # Returns of hash of all registered adapters where the keys are the registered names.
    def self.list
      @registered_adapters.dup
    end
    
    # Get an adapter by registered name.
    def self.get(name)
      name = name.to_sym
      raise ArgumentError, "adapter #{name} is not registered" unless @registered_adapters.has_key?(name)
      @registered_adapters[name]
    end
    
  end
end