module CurlyMustache
  class Base
    include Attributes::Types
    include Crud
    include Associations
    
    class_inheritable_accessor :connection
    class_inheritable_accessor :connection_config
    class_inheritable_accessor :attribute_definitions
    class_inheritable_accessor :typecaster
    
    self.attribute_definitions = Attributes::Definitions.new
    Attributes::Definer.new(self).define(:id, :integer)
    
    self.typecaster = Attributes::Typecaster.new
    
    def self.establish_connection(config)
      adapter_name = config[:adapter]
      require "adapters/#{adapter_name}"
      self.connection_config = config
      self.connection = "CurlyMustache::Adapters::#{adapter_name.camelize}".constantize.new(config)
    end
  
    def self.define_attributes(&block)
      yield(Attributes::Definer.new(self))
    end
    
    def id
      @attributes[:id]
    end
    
    def new_record?
      !!@new_record
    end
    
    def attributes
      @attributes
    end
  
    def read_attribute(name)
      self.class.check_attribute_defined(name)
      @attributes[name.to_sym]
    end
  
    def write_attribute(name, value)
      self.class.check_attribute_defined(name)
      type = self.class.attribute_definitions[name][:type]
      @attributes[name.to_sym] = typecast(:write, type, value)
    end
    
    def ==(other)
      self.attributes  == other.attributes and
      self.new_record? == other.new_record?
    end
  
  private

    def self.id_to_key(id)
      "#{self.name.underscore}_#{id}"
    end
  
    def self.ids_to_keys(ids)
      [ids].flatten.collect{ |id| id_to_key(id) }
    end
  
    def self.key_to_id(key)
      key.split("_").last
    end
  
    def self.keys_to_ids(keys)
      keys.collect{ |key| key_to_id(key) }
    end
  
    def self.attribute_defined?(name)
      self.attribute_definitions.has_key?(name.to_sym)
    end
  
    def self.check_attribute_defined(name)
      raise AttributeNotDefinedError, "unexpected attribute: #{name}" unless attribute_defined?(name)
    end
    
    def key
      raise NoKeyError unless id
      self.class.id_to_key(id)
    end
    
    def typecast(scope, type, value)
      self.class.typecaster.cast(scope, type, value)
    end
  
  end
  
end