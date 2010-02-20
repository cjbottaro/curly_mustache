require 'cassandra'

module CurlyMustache
  module Adapters
    class Cassandra < Abstract
      
      def read_config(options)
        options = options.symbolize_keys
        @client = ::Cassandra.new(options[:keyspace], options[:server])
        @column_family = (options[:column_family] || @class.name.pluralize).to_sym
      end
      
      def put(key, value)
        @client.insert(@column_family, key, value)
      end
      
      def get(key)
        @client.get(@column_family, key)
      end
      
    end
  end
end