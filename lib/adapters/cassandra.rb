require 'cassandra'

module CurlyMustache
  module Adapters
    class Cassandra < Abstract
      
      def read_config(options)
        options = options.symbolize_keys
        @client = ::Cassandra.new(options[:keyspace], options[:server])
        @column_family = options[:column_family] && options[:column_family].to_sym
      end
      
      def column_family
        @column_family || @class.name.pluralize.to_sym
      end
      
      def put(key, value)
        @client.insert(column_family, key, value)
      end
      
      def get(key)
        result = @client.get(column_family, key)
        result.empty? ? nil : result
      end
      
      def delete(key)
        @client.remove(column_family, key)
      end
      
      def flush_db
        @client.clear_keyspace!
      end
      
    end
  end
end