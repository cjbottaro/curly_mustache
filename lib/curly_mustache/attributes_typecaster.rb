module CurlyMustache
  module Typecaster
    
    class Base
    
      def cast_for_read(type, value)
        return nil if value.nil?
        method_name = "read_#{type}"
        dispatch(method_name, value)
      end
    
      def cast_for_write(type, value)
        return nil if value.nil?
        method_name = "write_#{type}"
        dispatch(method_name, value)
      end
    
    private
    
      def dispatch(method_name, value)
        respond_to?(method_name) ? send(method_name, value) : value
      end
    
    end
    
    class Default < Base
      
      VALID_TYPES = %w[array boolean date datetime float integer string time]
      
      def write_array(value)
        value.to_a
      end

      def write_boolean(value)
        case value
        when String
          %w[t true 1 y yes].include?(value.downcase)
        else
          [true, 1].include?(value)
        end
      end
      
      def write_date(value)
        value.to_date
      end
      
      def write_datetime(value)
        value.to_datetime.utc
      end
      
      def write_float(value)
        value.to_f
      end
      
      def write_integer(value)
        value.to_i
      end
      
      def write_string(value)
        value.to_s
      end
      
      def write_time(value)
        value.to_time.utc
      end
      
      def read_datetime(value)
        value.in_time_zone
      end
      
      def read_time(value)
        value.in_time_zone
      end
      
    end
    
  end
end