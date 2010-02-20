module CurlyMustache
  module Connection
    
    def self.included(mod)
      mod.class_eval do
        class_inheritable_accessor :connection
      end
      mod.meta_class.class_eval do
        # HACK!!  Connection is an inheritable attribute, so it is duped in the derived class.
        # The problem is that a reference to the base class is stored in @class.  We need to
        # change it to the derived class.  See SerializationTest::test_proper_connection.
        def inherited_with_connection(klass)
          inherited_without_connection(klass)
          klass.connection.instance_variable_set("@class", klass)
        end
        alias_method_chain :inherited, :connection
      end
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def establish_connection(config)
        adapter_name = config[:adapter].to_s
        require "adapters/#{adapter_name}"
        adapter = "CurlyMustache::Adapters::#{adapter_name.camelize}".constantize.new(self, config)
        self.connection = Connection.new(self, adapter)
      end
      
    end
    
    module InstanceMethods
    end
    
    class Connection
      
      attr_reader :adapter
      delegate :delete, :flush_db, :lock, :unlock, :locked?, :to => :adapter
      
      def initialize(klass, adapter)
        @class, @adapter = klass, adapter
      end
      
      def get(key)
        serialize_out(adapter.get(key))
      end
      
      def mget(keys)
        adapter.mget(keys).collect{ |value| serialize_out(value)  }
      end
      
      def put(key, value)
        adapter.put(key, serialize_in(value))
      end
      
    private
      
      def serialize_in(value)
        value and @class.serializer.run_in(value)
      end
      
      def serialize_out(value)
        value and @class.serializer.run_out(value)
      end
      
    end
    
  end
end