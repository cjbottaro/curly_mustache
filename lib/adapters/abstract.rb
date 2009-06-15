module CurlyMustache
  module Adapters
    class Abstract
      
      def initialize(config)
        raise RuntimeError, "Not implemented!"
      end
      
      def get(key)
        raise RuntimeError, "Not implemented!"
      end
      
      def mget(keys)
        keys.collect{ |key| get(key) }.compact
      end
      
      def put(key, value)
        raise RuntimeError, "Not implemented!"
      end
      
      def delete(key)
        raise RuntimeError, "Not implemented!"
      end
      
      # Needed for tests.
      def flush_db
        raise RuntimeError, "Not implemented!"
      end
      
    end
  end
end