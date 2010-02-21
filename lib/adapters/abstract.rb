module CurlyMustache
  module Adapters
    class Abstract
      attr_reader :adapter
      
      def initialize(config)
        @adapter = self.class.name.split("::").last.underscore.to_sym
        read_config(config)
      end
      
      def read_config(config)
        raise NotImplementedError
      end
      
      def set_class(klass)
        @class = klass
      end
      
      def get(key)
        raise NotImplementedError
      end
      
      def mget(keys)
        keys.collect{ |key| get(key) }.compact
      end
      
      def put(key, value)
        raise NotImplementedError
      end
      
      def delete(key)
        raise NotImplementedError
      end
      
      # Needed for tests.
      def flush_db
        raise NotImplementedError
      end
      
      def lock(key)
        raise NotImplementedError
      end
      
      def unlock(key)
        raise NotImplementedError
      end
      
    end
  end
end