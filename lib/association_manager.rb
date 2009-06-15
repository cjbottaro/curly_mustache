module CurlyMustache
  class AssociationManager
    
    def initialize(owner)
      @owner = owner
      @cache = {}
    end
    
    def get(name, reload = false)
      return cache_get(name) if cache_hit?(name) and !reload
      reflection = reflection(name)
      if reflection.arity == :one
        get_one(reflection)
      else
        get_many(reflection)
      end
    end
    
    def get_one(reflection)
      klass  = reflection.class_name.constantize
      fkey   = @owner.send(reflection.foreign_key)
      object = klass.find(fkey)
      cache_set(reflection.name, object)
    end
    
    def get_many(reflection)
      object = AssociationCollection.new(@owner, reflection)
      cache_set(reflection.name, object)
    end
    
    def set(name, object)
      reflection = reflection(name)
      if reflection.arity == :one
        set_one(reflection, object)
      else
        set_many(reflection, object)
      end
    end
    
    def set_one(reflection, object)
      if object.nil?
        object_id = nil
      elsif object.kind_of?(CurlyMustache::Base)
        object_id = object.id
      else
        raise InvalidAssociation
      end
      @owner.send("#{reflection.foreign_key}=", object_id)
      cache_set(reflection.name, object)
    end
    
    def set_many(reflection, objects)
      objects = [] if objects.blank?
      raise InvalidAssociation unless objects.all?{ |object| object.kind_of?(CurlyMustache::Base) }
      if objects.blank?
        object_ids = []
      else
        object_ids = objects.collect{ |object| object.id }
      end
      object_ids = object_ids.join(',') if attribute_type(reflection.foreign_key) == :string
      @owner.send("#{reflection.foreign_key}=", object_ids)
      cache_set(reflection.name, objects)
    end
  
  private
    
    def cache_hit?(name)
      @cache.has_key?(name.to_s)
    end
    
    def cache_get(name)
      @cache[name.to_s]
    end
    
    def cache_set(name, object)
      @cache[name.to_s] = object
    end
    
    def reflection(name)
      @owner.class.associations[name.to_sym]
    end
    
    def attribute_type(name)
      @owner.send(:attribute_type, name)
    end
    
  end
end