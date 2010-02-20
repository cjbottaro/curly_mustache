module CurlyMustache
  
  module Crud
    
    def self.included(mod)
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def create(attributes = {})
        returning(new) do |record|
          record.attributes = attributes
          record.save
        end
      end
      
      def find(*ids)
        ids = [ids].flatten
        if ids.length == 1
          find_one(ids.first)
        else
          find_many(ids, :raise)
        end
      end
      
      def find_all_by_id(*ids)
        ids = [ids].flatten
        find_many(ids)
      end
      
      def find_by_id(id)
        find_one(id)
      rescue RecordNotFound
        nil
      end
      
      def delete_all(*ids)
        ids_to_keys(ids).each{ |key| connection.delete(key) }
      end
      
      def destroy_all(*ids)
        find(ids).each{ |record| record.destroy }
      end
    
    private
      
      def id_to_key(id)
        raise NoKeyError if id.blank?
        "#{self}:#{id}"
      end
      
      def ids_to_keys(ids)
        [ids].flatten.collect{ |id| id_to_key(id) }
      end
      
      def find_one(id)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if id.blank?
        new.send(:read, :id => id)
      end
      
      def find_many(ids, should_raise = false)
        hashes = mget(ids_to_keys(ids))
        if should_raise and ids.length != hashes.length
          raise RecordNotFound, find_many_error_message(ids, hashes)
        else
          ids.zip(hashes).collect{ |id, attributes| new.send(:read, :attributes => attributes) }
        end
      end
      
      def find_many_error_message(ids, hashes)
        ids_string = ids.join(",")
        models_name = name.pluralize
        found, wanted = hashes.length, ids.length
        "Couldn't find all #{models_name} with IDs (#{ids_string}) (found #{found} results, but was looking for #{wanted})"
      end
      
    end
    
    module InstanceMethods
      
      def initialize(attributes = {})
        @attributes = {}
        @new_record = true
        self.attributes = attributes
      end
      
      def new_record?
        !!@new_record
      end
      
      def reload
        returning(self){ read }
      end
      
      def save
        returning(self){ new_record? ? create : update }
      end
      
      def destroy
        delete
      end
      
    private
      
      def generate_id
        Digest::MD5.hexdigest(rand.to_s + Time.now.to_s)
      end
      
      def id_to_key(id)
        self.class.send(:id_to_key, id)
      end
      
      def key
        id_to_key(id)
      end
      
      def create
        @attributes["id"] = generate_id if id.blank?
        update_without_callbacks
      end
      
      def create_with_callbacks
        _run_create_callbacks do
          _run_save_callbacks do
            create_without_callbacks
          end
        end
      end
      
      alias_method_chain :create, :callbacks
      
      def read(options = {})
        options = options.reverse_merge :id => nil,
                                        :attributes => nil,
                                        :keep_new => false
        
        if options[:attributes]
          set_attributes(options[:attributes])
        else
          if options[:id]
            _id, _key = options[:id], id_to_key(options[:id])
          else
            _id, _key = id, key
          end
          attributes = get(_key) || raise(RecordNotFound, "Couldn't find #{self.class.name} with ID=#{_id}")
          set_attributes(attributes)
        end
        
        @new_record = options[:keep_new]
        
        self
      end
      
      def read_with_callbacks(*args)
        _run_find_callbacks do
          read_without_callbacks(*args)
        end
      end
      
      alias_method_chain :read, :callbacks
      
      def update
        put(key, attributes)
        @new_record = false
      end
      
      def update_with_callbacks
        _run_update_callbacks do
          _run_save_callbacks do
            update_without_callbacks
          end
        end
      end
      
      alias_method_chain :update, :callbacks
      
      def delete
        self.class.delete_all(id)
        self.freeze
      end
      
      def delete_with_callbacks
        _run_destroy_callbacks do
          delete_without_callbacks
        end
      end
      
      alias_method_chain :delete, :callbacks
      
    end # end module InstanceMethods
    
  end
  
end