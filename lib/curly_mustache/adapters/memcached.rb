require 'memcache'

module CurlyMustache
  module Adapters
    # You can use this adapter with any data store that speaks Memcached.  The adapter uses
    # {memcache-client}[http://github.com/mperham/memcache-client].  The <tt>:servers</tt> key in
    # the hash passed to CurlyMustache::Base#establish_connection will be the first argument to
    # <tt>MemCache.new</tt> and entire hash will be passed as the second argument.
    class Memcached < Abstract
      
      # <tt>config[:servers]</tt> will be passed as the first argument to <tt>MemCache.new</tt> and
      # <tt>config</tt> itself will be passed as the second argument.
      def initialize(config)
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