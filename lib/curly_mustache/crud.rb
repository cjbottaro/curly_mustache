module CurlyMustache
  
  module Crud
    
    def self.included(mod)
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def generate_id
        Digest::MD5.hexdigest(rand.to_s + Time.now.to_s)
      end
      
      def create(attributes = {})
        returning(new(attributes)){ |record| record.save }
      end
      
      def create!(attributes = {})
        new(attributes).save!
      end
      
      def find(*ids)
        ids = [ids].flatten
        if ids.length == 1
          find_one(ids.first)
        else
          find_many(ids)
        end
      end
      
      def find_all_by_id(*ids)
        ids = [ids].flatten
        find_many(ids, :raise => false)
      end
      
      def delete_all(*ids)
        ids_to_keys(ids).each{ |key| connection.delete(key) }
      end
      
      def destroy_all(*ids)
        find(ids).each{ |record| record.destroy }
      end
    
    private
      
      def find_one(id)
        raise RecordNotFound, "Couldn't find #{self} without an ID" if id.blank?
        raise RecordNotFound, "Couldn't find #{self} with ID=#{id}" if (data = connection.get(id_to_key(id))).blank?
        returning(new){ |record| record.send(:load, data) }
      end
      
      def find_many(ids, options = {})
        options = options.reverse_merge :raise => true
        keys = ids_to_keys(ids)
        datas = connection.mget(keys)
        if options[:raise] && keys.length != datas.length
          raise RecordNotFound, "Couldn't find all #{self.name} with IDs (#{ids.join(',')}) (found #{datas.length} results, but was looking for #{ids.length})"
        else
          datas.collect{ |data| returning(new){ |record| record.send(:load, data) } }
        end
      end
      
    end
    
    module InstanceMethods
      
      def initialize(attributes = {})
        @attributes = {}
        @new_record = true
        attributes.each{ |k, v| write_attribute(k, v) }
      end
      
      def reload
        returning(self){ @attributes = self.class.find(id).attributes }
      end
      
      def save
        save!
        true
      rescue ValidationError => e
        false
      end
      
      def save!
        new_record? ? create : update
        self
      end
      
      def destroy
        self.class.delete_all(id)
        self.freeze
      end
      
    private
    
      def set_id
        if id.blank?
          @attributes["id"] = self.class.generate_id
        else
          true
        end
      end
      
      def create
        set_id and store
      end
      
      def update
        store
      end
      
      def load(data)
        @attributes = data
        @new_record = false
      end
      
      def store
        connection.put(key, @attributes)
        @new_record = false
      end
      
    end # end module InstanceMethods
    
  end
  
end