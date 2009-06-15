module CurlyMustache
  module Attributes
    class Definer
    
      def initialize(klass)
        @class = klass
      end
    
      def define(name, type, options = {})
        @class.check_attribute_type(type)
        definition = { :type => type }
        @class.attribute_definitions[name.to_sym] = definition
        @class.class_eval <<-END
          def #{name}
            read_attribute('#{name}')
          end
        
          def #{name}=(value)
            write_attribute('#{name}', value)
          end
        END
      end
    
    end
  end
end