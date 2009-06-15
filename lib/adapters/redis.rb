require 'redis'

module CurlyMustache
  module Adapters
    class Redis < Abstract
      
      def initialize(config)
        @redis = ::Redis.new(config)
      end
      
      def get(key)
        (data = @redis.get(key)) and Marshal.load(data)
      end
      
      def mget(keys)
        keys = keys.collect(&:to_s)
        @redis.mget(*keys).compact.collect{ |value| Marshal.load(value) }
      end
      
      def put(key, value)
        @redis.set(key, Marshal.dump(value))
      end
      
      def delete(key)
        @redis.delete(key)
      end
      
      def raw
        @redis
      end
      
    end
  end
end