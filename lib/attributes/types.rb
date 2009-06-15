module CurlyMustache
  module Attributes
    module Types
      
      DEFAULT_ATTRIBUTE_TYPES = %w[array integer string date time datetime boolean float].freeze
      
      def self.included(mod)
        mod.class_eval{ class_inheritable_accessor :attribute_types }
        mod.attribute_types = DEFAULT_ATTRIBUTE_TYPES.dup
        mod.extend(ClassMethods)
        mod.send(:include, InstanceMethods)
      end
      
      module InstanceMethods
        
      private
        
        def attribute_type(name)
          self.class.attribute_definitions[name.to_sym][:type]
        end
        
      end # end module InstanceMethods
      
      module ClassMethods
        
        def valid_attribute_type?(type)
          self.attribute_types.include?(type.to_s)
        end
        
        def check_attribute_type(type)
          raise InvaildAttributeType, "unexpected attribute type: #{type}" unless valid_attribute_type?(type)
        end
        
      end # end module ClassMethods
      
    end # end module Types
  end # end module Attributes
end # end module CurlyMustache
      