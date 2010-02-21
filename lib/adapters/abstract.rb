module CurlyMustache
  module Adapters
    class Abstract
      
      def initialize(config)
        read_config(config)
      end
      
      def read_config(config)
        raise NotImplementedError
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