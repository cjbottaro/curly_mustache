module CurlyMustache
  module Adapters
    class Abstract
      
      def initialize(cm_class, config)
        @config, @cm_class = config, cm_class
        read_config(config)
      end
      
      def read_config(config)
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
      
      def lock(key)
        raise RuntimeError, "Not Implemented!"
      end
      
      def unlock(key)
        raise RuntimeError, "Not Implemented!"
      end
      
      def marshal_load(data); create_marshal_methods; marshal_load(data); end
      def marshal_dump(data); create_marshal_methods; marshal_dump(data); end
      
      def create_marshal_methods
        if @cm_class.respond_to?(:marshal_load) and @cm_class.respond_to?(:marshal_dump)
          class_eval do
            def marshal_load(data); @cm_class.marshal_load(data); end
            def marshal_dump(data); @cm_class.marshal_dump(data); end
          end
        elsif !@cm_class.respond_to?(:marshal_load) and !@cm_class.respond_to?(:marshal_dump)
          class_eval do
            def marshal_load(data); Marshal.load(data); end
            def marshal_dump(data); Marshal.dump(data); end
          end
        else
          raise RuntimeError, "If your CurlyMustache class #{@cm_class} defines one marshal method, it must define the other."
        end
      end
      
    end
  end
end