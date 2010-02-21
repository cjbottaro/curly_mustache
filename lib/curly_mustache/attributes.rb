require "curly_mustache/attributes/manager"

module CurlyMustache
  
  # It looks like typecasting happens at assignment for ActiveRecord, so we're just going to follow that.
  #   user.account_id = "test"
  #   user.account_id
  #   => 0
  module Attributes
  
    def self.included(mod)
      mod.class_eval do
        class_inheritable_accessor :attribute_manager
        class_inheritable_accessor :allow_settable_id
      end
      mod.attribute_manager = Manager.new
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def attribute(name, type, options = {})
        attribute_manager.define(self, name, type, options)
      end
      
      def attributes
        attribute_manager.definitions
      end
      
      def attribute_type(name)
        attribute_manager[name].type
      end
      
      def allow_settable_id!(settable = true)
        self.allow_settable_id = settable
      end
      
    end
    
    module InstanceMethods
      
      def attributes=(hash)
        hash.stringify_keys.each{ |k, v| write_attribute(k, v) }
      end
      
      def attributes
        @attributes.dup
      end
      
      def read_attribute(name)
        @attributes[name.to_s]
      end
      
      def write_attribute(name, value)
        send("#{name}_will_change!") # ActiveModel::Dirty
        @attributes[name.to_s] = value
      end
      
      def write_attribute_with_typecast(name, value)
        casted_value = attribute_manager[name].cast(value)
        write_attribute_without_typecast(name, casted_value)
      end
      
      alias_method_chain :write_attribute, :typecast
      
      def write_attribute_with_id_guard(name, value)
        raise IdNotSettableError, "not allowed to set id" if name.to_s == "id" and !allow_settable_id
        write_attribute_without_id_guard(name, value)
      end
      
      alias_method_chain :write_attribute, :id_guard
      
    private
      
      # This is like #attributes= but allows for setting the id.  It's intended to be used
      # internally by methods like #read.
      def set_attributes(hash)
        hash.stringify_keys.each{ |k, v| write_attribute_without_id_guard(k, v) }
      end
      
    end
  
  end
end