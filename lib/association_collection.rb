module CurlyMustache
  class AssociationCollection
    
    delegate :[], :inspect, :length, :to => :implementation
    
    def initialize(owner, reflection)
      @owner, @reflection = owner, reflection
      reload
    end
    
    def reload
      klass = @reflection[:class_name].constantize
      @array = klass.find(get_ids)
    end
    
    def to_a
      @array.dup
    end
    
    def <<(value)
      raise InvalidAssociation unless value.kind_of?(CurlyMustache::Base)
      @array << value
      ids = get_ids
      ids << value.id
      set_ids(ids)
    end
    
  private
    
    def implementation
      @array
    end
    
    def get_ids
      ids = @owner.send(foreign_key)
      if fkey_type == :string
        ids.split(',')
      else
        ids
      end
    end
    
    def set_ids(ids)
      ids = ids.join(',') if fkey_type == :string
      @owner.send("#{foreign_key}=", ids)
    end
    
    def foreign_key
      @reflection[:foreign_key]
    end
    
    def fkey_type
      @owner.send(:attribute_type, foreign_key)
    end
    
  end
end