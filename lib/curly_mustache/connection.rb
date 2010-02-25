module CurlyMustache
  # NOTE: The way this is implemented makes CurlyMustache not thread safe!
  # 
  # You are probably looking for {establish_connection}[link:/classes/CurlyMustache/Connection/ClassMethods.html#M000084].
  module Connection
    
    def self.included(mod)
      mod.class_eval do
        class_inheritable_accessor :_connection
      end
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      # Establishes a connection using the adapter specified in <tt>config[:adapter]</tt>.
      # If you call +establish_connection+ on CurlyMustache::Base, then all models will
      # use that connection unless +establish_connection+ is called directly on a model class.
      # Note that +config+ itself is passed to the adapter's constructor.
      # 
      # Ex:
      #   CurlyMustache::Base.establish_connection(:adapter => :memcached, :servers => "localhost:11211")
      def establish_connection(config)
        config = config.symbolize_keys
        self._connection = Adapters.get(config[:adapter]).new(config)
      end
      
      def connection
        _connection.model_class = self
        _connection
      end
      
    end
    
    module InstanceMethods
      
      def connection
        self.class.connection
      end
      
      def send_attributes(attributes)
        attributes
      end
      
      def recv_attributes(attributes)
        attributes
      end
      
    end
    
  end
end