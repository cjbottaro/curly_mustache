require "curly_mustache/default_types"

module CurlyMustache
  class Base
    
    include Connection
    include Attributes
    include Crud
    
    extend ActiveModel::Callbacks
    include ActiveModel::Validations
    include ActiveModel::Dirty
    
    define_model_callbacks :create, :destroy, :save, :update, :validation, :validation_on_create, :validation_on_update, :only => [:before, :after]
    define_model_callbacks :find, :only => :after
    
    # Set this to true if you want to set your own ids as opposed to having CurlyMustache
    # automatically generate them for you.  Ex:
    #   class User
    #     self.allow_settable_id = true
    #     attribute :name, :string
    #   end
    #   User.create(:id => 123, :name => "blah")
    #   User.find(123)
    allow_settable_id!(false)
    
    attribute :id, :string
    
    def ==(other)
      self.attributes  == other.attributes and
      self.new_record? == other.new_record?
    end
    
  end
  
end