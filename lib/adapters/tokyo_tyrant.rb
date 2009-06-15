require 'rufus/tokyo/tyrant'

module CurlyMustache
  module Adapters
    class TokyoTyrant < Abstract
      
      def initialize(config)
        config = config.reverse_merge :server => "localhost", :port => 1978
        @db = Rufus::Tokyo::Tyrant.new(config[:server], config[:port])
      end
      
      def get(key)
        (data = @db[key]) and Marshal.load(data)
      end
      
      def mget(keys)
        keys = keys.collect(&:to_s)
        results = @db.lget(keys)
        keys.inject([]) do |memo, key|
          data = results[key]
          memo << Marshal.load(data) if data
          memo
        end
      end
      
      def put(key, value)
        @db[key] = Marshal.dump(value)
      end
      
      def delete(key)
        @db.delete(key) ? true : false
      end
      
      def flush_db
        @db.clear
      end
      
      def raw
        @db
      end
      
    end
  end
end