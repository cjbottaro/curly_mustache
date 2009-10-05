module CurlyMustache

  class AttributesManager
    attr_accessor :typecaster
  
    def initialize(klass)
      @class = klass
      @typecaster = Typecaster::Default.new
      @definitions = {}
    end
  
    def define(name, type, options = {})
      check_type(type)
      @definitions[name.to_s] = { :type => type, :options => options }
      @class.class_eval <<-END
        def #{name}
          read_attribute(:#{name})
        end
        def #{name}=(value)
          write_attribute(:#{name}, value)
        end
      END
    end
  
    def defined?(name)
      @definitions.has_key?(name.to_s)
    end
  
    def cast_for_read(name, value)
      @typecaster.cast_for_read(type(name), value)
    end
  
    def cast_for_write(name, value)
      @typecaster.cast_for_write(type(name), value)
    end
    
    def type(name)
      raise AttributeNotDefinedError, name unless self.defined?(name)
      @definitions[name.to_s][:type]
    end
  
  private
  
    def check_type(type)
      raise InvaildAttributeType, "unexpected attribute type: #{type}" unless valid_type?(type)
    end
  
    def valid_type?(type)
      @typecaster.class::VALID_TYPES.collect(&:to_s).include?(type.to_s)
    end
  
  end

end