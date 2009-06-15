require 'association_manager'

module CurlyMustache
  module Associations
    
    def self.included(mod)
      mod.class_eval{ class_inheritable_accessor :associations }
      mod.associations = {}
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def association(name, options = {})
        # Sanitize arguments.
        name = name.to_s
        
        # Default options.
        options = options.reverse_merge :arity => :many,
                                        :name => name
        
        # More default options (based off previous default options).
        if options[:arity] == :many
          options = options.reverse_merge :class_name => name.singularize.camelize,
                                          :foreign_key => name.singularize.foreign_key.pluralize
        else
          options = options.reverse_merge :class_name => name.camelize,
                                          :foreign_key => name.foreign_key
        end
        
        # Save the association reflection info.
        self.associations[name.to_sym] = options.to_struct
        
        # Create associations accessors.
        class_eval <<-END
          def #{name}(reload = false)
            association_manager.get(:#{name}, reload)
          end
          def #{name}=(value)
            association_manager.set(:#{name}, value)
          end
        END
      end
      
    end
    
    module InstanceMethods
      
    private
    
      def association_manager
        @associations_manager ||= AssociationManager.new(self)
      end
      
    end
    
  end # module Crud
end # module CurlyMustache