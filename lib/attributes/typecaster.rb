module CurlyMustache
  module Attributes
    class Typecaster
      
      SCOPES = %w[read write load store]
      
      def initialize
      end
      
      def cast(scope, type, value)
        method_name = "to_#{scope}_#{type}"
        return nil if value.nil?
        respond_to?(method_name) ? send(method_name, value) : value
      end
      
      SCOPES.each do |scope|
        class_eval <<-END
          def cast_for_#{scope}(type, value)
            cast('#{scope}', type, value)
          end
        END
      end
      
      def to_write_array(value)
        value.to_a
      end
      
      def to_write_integer(value)
        value.to_i
      end
      
      def to_write_string(value)
        value.to_s
      end
      
      def to_write_date(value)
        value.to_date
      end
      
      def to_write_time(value)
        value.to_time.utc
      end
      
      def to_write_datetime(value)
        value.to_datetime.utc
      end
      
      def to_write_boolean(value)
        case value
        when String
          %w[t true 1 y yes].include?(value.downcase)
        else
          [true, 1].include?(value)
        end
      end
      
      def to_write_float(value)
        value.to_f
      end
      
      def to_read_time(value)
        value.time_in_zone
      end
      
      def to_read_datetime(value)
        value.time_in_zone
      end
      
    end
  end
end