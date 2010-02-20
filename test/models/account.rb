class Account < CurlyMustache::Base
  attribute :name, :string
  attribute :created_at, :time
  attribute :updated_at, :time
  
  CALLBACKS = %w[before_create after_create before_save after_save before_update after_update before_destroy after_destroy after_find]
  
  cattr_reader :callback_counts
  
  def self.reset_callback_counts
    @@callback_counts = CALLBACKS.inject({}){ |memo, callback_name| memo[callback_name.to_sym] = 0; memo }
  end
  
  CALLBACKS.each do |callback_name|
    class_eval <<-end_eval
      #{callback_name} :#{callback_name}_cb
      def #{callback_name}_cb
        @@callback_counts[:#{callback_name}] += 1
      end
    end_eval
  end
  
  reset_callback_counts
end