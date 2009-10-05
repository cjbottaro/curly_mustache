module CurlyMustache

  module Attributes
  
    def self.included(mod)
      mod.class_eval do
        class_inheritable_accessor :attribute_manager
        class_inheritable_accessor :attribute_typecaster
      end
      mod.attribute_manager = AttributesManager.new(mod)
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
  
    module ClassMethods
    
      def attribute(name, type, options = {})
        self.attribute_manager.define(name, type, options)
      end
    
    end
  
    module InstanceMethods
    
      def read_attribute(name)
        @attributes[name.to_s]
      end
    
      def read_attribute_with_typecast(name)
        uncasted_value = read_attribute_without_typecast(name)
        self.attribute_manager.cast_for_read(name, uncasted_value)
      end
      alias_method_chain :read_attribute, :typecast
    
      def write_attribute(name, value)
        @attributes[name.to_s] = value
      end
    
      def write_attribute_with_typecast(name, value)
        casted_value = self.attribute_manager.cast_for_write(name, value)
        write_attribute_without_typecast(name, casted_value)
      end
      alias_method_chain :write_attribute, :typecast
    
    end
  
  end
end