module CurlyMustache
  class Base
    DEFAULT_LOCK_PREFIX = "lock"
    
    include Attributes
    include Crud
    include Associations
    include Locking
    
    class_inheritable_accessor :connection
    class_inheritable_accessor :connection_config
    
    attribute :id, :string
    
    def self.establish_connection(config)
      adapter_name = config[:adapter].to_s
      require "adapters/#{adapter_name}"
      self.connection_config = config
      self.connection = "CurlyMustache::Adapters::#{adapter_name.camelize}".constantize.new(self, config)
    end
    
    def id
      @attributes["id"]
    end
    
    def new_record?
      !!@new_record
    end
    
    def attributes
      @attributes.dup
    end
    
    def ==(other)
      self.attributes  == other.attributes and
      self.new_record? == other.new_record?
    end
  
  private

    def self.id_to_key(id)
      if id.blank?
        raise NoKeyError
      else
        "#{self}:#{id}"
      end
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
      self.class.id_to_key(id)
    end
    
    def typecast(scope, type, value)
      self.class.typecaster.cast(scope, type, value)
    end
  
  end
  
end