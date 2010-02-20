module CurlyMustache
  module Connection
    
    def self.included(mod)
      mod.class_eval do
        class_inheritable_accessor :connection
      end
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def establish_connection(config)
        adapter_name = config[:adapter].to_s
        require "adapters/#{adapter_name}"
        adapter = "CurlyMustache::Adapters::#{adapter_name.camelize}".constantize.new(self, config)
        self.connection = adapter
      end
      
      def get(key)
        (value = connection.get(key)) and serializer.run_out(value)
      end
      
      def put(key, value)
        connection.put(key, serializer.run_in(value))
      end
      
      def mget(keys)
        connection.mget(keys).collect{ |value| serializer.run_out(value) }
      end
      
    end
    
    module InstanceMethods
      
      def get(key); self.class.get(key); end
      def put(key, value); self.class.put(key, value); end
      def mget(keys); self.class.mget(keys); end
      
    end
    
  end
end