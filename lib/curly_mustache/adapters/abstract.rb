module CurlyMustache
  module Adapters
    # Subclass this class to make new adapters.
    #
    # The required methods for basic functionality are: +new+, +get+, +put+ and +delete+.
    #
    # If you want to include CurlyMustache::Locking, then you must implement +lock+ and +unlock+ and <tt>locked?</tt>.
    #
    # If you want unit tests to run using your adapter, you must implement +flush_db+.
    class Abstract
      # Holds a reference to the class that is currently using this adapter.
      attr_accessor :model_class
      
      ############
      # REQUIRED #
      ############
      
      # Implementing this is required for basic functionality.
      # +config+ is passed directly from {#establish_connection}[link:/classes/CurlyMustache/Connection/ClassMethods.html#M000089].
      def initialize(config)
        raise NotImplementedError
      end
      
      # Implementing this is required for basic functionality.
      # The output should be a hash of attributes that will be used to instantiate a model,
      # or the input of an "in" serializer if one is being used.
      def get(key)
        raise NotImplementedError
      end
      
      # Implementing this is required for basic functionality.
      # +value+ is the model's attributes hash, or the output of an "out" serializer if one is being used.
      def put(key, value)
        raise NotImplementedError
      end
      
      # Implementing this is required for basic functionality.
      def delete(key)
        raise NotImplementedError
      end
      
      ############
      # OPTIONAL #
      ############
      
      # Implement this if you want unit tests to run for your adapter.
      def flush_db
        raise NotImplementedError
      end
      
      # Implement this if you want to include the <tt>CurlyMustache::Locking<tt> module into your model class.
      def lock(key)
        raise NotImplementedError
      end
      
      # Implement this if you want to include the <tt>CurlyMustache::Locking<tt> module into your model class.
      def unlock(key)
        raise NotImplementedError
      end
      
      # Implement this if you want to include the <tt>CurlyMustache::Locking<tt> module into your model class.
      def locked?(key)
        raise NotImplementedError
      end
      
      ############
      # PROVIDED #
      ############
      
      # The default implementation of this just iterates over keys calling +get+ on them.  Override this
      # implementation if your data store has a more efficient way of retrieving multiple keys.  The
      # return value should be an array of values where each value follow the same rules for the output
      # of +get+.  Also the order of the values in the array should match the order of the +keys+ argument.
      def mget(keys)
        keys.collect{ |key| get(key) }.compact
      end
      
      # This returns the name of the adapter which can be used in {#establish_connection}[link:/classes/CurlyMustache/Connection/ClassMethods.html#M000089].
      # If your adapter class's name is "MyFunkyAdapter", then this method will return <tt>:my_funky_adapter</tt>.
      def adapter_name
        @adapter_name ||= self.class.name.split("::").last.underscore.to_sym
      end
      
    end
  end
end