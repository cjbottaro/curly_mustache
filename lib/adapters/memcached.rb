require 'memcache'

module CurlyMustache
  module Adapters
    class Memcached < Abstract
      
      def read_config(config)
        config = config.reverse_merge :servers => "localhost:11211"
        @cache = MemCache.new(config[:servers], config)
      end
      
      def get(key)
        @cache.get(key)
      end
      
      def mget(keys)
        keys = keys.collect(&:to_s)
        results = @cache.get_multi(*keys)
        results = results.collect{ |k, v| [k, v] }
        results.sort.collect{ |result| result[1] }
      end
      
      def put(key, value)
        @cache.set(key, value)
      end
      
      def delete(key)
        @cache.delete(key)
      end
      
      def flush_db
        @cache.flush_all
      end
      
      def lock(key, options = {})
        expires_in = options[:expires_in] || 0
        @cache.add(key, Time.now.to_s(:number), expires_in) == "STORED\r\n"
      end
      
      def unlock(key)
        delete(key) == "DELETED\r\n"
      end
      
      def locked?(key)
        !!@cache.get(key)
      end
      
    end
  end
end