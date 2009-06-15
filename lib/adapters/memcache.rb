require 'memcache'

module CurlyMustache
  module Adapters
    class Memcache < Abstract
      
      def initialize(config)
        config = config.reverse_merge :servers => "localhost:11211"
        @cache = MemCache.new(config[:servers], config)
      end
      
      def get(key)
        (data = @cache.get(key)) and Marshal.load(data)
      end
      
      def mget(keys)
        keys = keys.collect(&:to_s)
        results = @cache.get_multi(*keys)
        results = results.collect{ |k, v| [k, Marshal.load(v)] }
        results.sort.collect{ |result| result[1] }
      end
      
      def put(key, value)
        @cache.set(key, Marshal.dump(value))
      end
      
      def delete(key)
        @cache.delete(key)
      end
      
      def flush_db
        @cache.flush_all
      end
      
    end
  end
end