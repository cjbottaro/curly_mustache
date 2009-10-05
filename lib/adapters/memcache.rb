require 'memcache'

module CurlyMustache
  module Adapters
    class Memcache < Abstract
      
      def read_config(config)
        config = config.reverse_merge :servers => "localhost:11211"
        @cache = MemCache.new(config[:servers], config)
      end
      
      def get(key)
        (data = @cache.get(key)) and marshal_load(data)
      end
      
      def mget(keys)
        keys = keys.collect(&:to_s)
        results = @cache.get_multi(*keys)
        results = results.collect{ |k, v| [k, marshal_load(v)] }
        results.sort.collect{ |result| result[1] }
      end
      
      def put(key, value)
        @cache.set(key, marshal_dump(value))
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
      
    end
  end
end