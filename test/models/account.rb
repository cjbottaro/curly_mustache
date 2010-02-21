class Account < CurlyMustache::Base
  attribute :name, :string, :allow_nil => false
  attribute :created_at, :time
  attribute :updated_at, :time
  
  CALLBACKS = %w[before_create after_create
                 before_save after_save
                 before_update after_update
                 before_destroy after_destroy
                 before_validation after_validation
                 before_validation_on_create after_validation_on_create
                 before_validation_on_update after_validation_on_update
                 after_find]
  
  attr_accessor :callbacks_made
  
  # This just defines methods for each callback that simply records in #callbacks_made that
  # the callback was called.
  CALLBACKS.each do |callback_name|
    class_eval <<-end_eval
      #{callback_name} :#{callback_name}_cb
      def #{callback_name}_cb
        @callbacks_made ||= []
        @callbacks_made << :#{callback_name}
      end
    end_eval
  end
  
  validates_presence_of :name
  
end