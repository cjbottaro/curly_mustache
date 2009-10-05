require "timeout"

module CurlyMustache
  module Locking
    
    def self.included(mod)
      mod.send(:extend,  ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      def lock(id, timeout = nil)
        if timeout.nil?
          connection.lock(lock_key(id))
        else
          lock_with_timeout(id, timeout)
        end
      end
      
      def lock_with_timeout(id, timeout)
        start_time = Time.now
        while (Time.now.to_f - start_time.to_f) < timeout
          connection.lock(lock_key(id)) and return true
          sleep(0.1)
        end
        raise Timeout::Error, "aquiring lock for #{id_to_key(id)}"
      end
      
      def unlock(id)
        connection.unlock(lock_key(id))
      end
      
      def lock_and_find(id, timeout = nil, &block)
        lock(id, timeout) or return false
        unlock(id) and return if (record = find(id)).blank?
        if block_given?
          do_locked_block(id, record, &block)
        else
          record
        end
      end
      
      def do_locked_block(id, record, &block)
        yield(record)
      rescue Exception
        raise
      ensure
        unlock(id)
      end
      
      def lock_key(id)
        "#{lock_prefix}:#{id_to_key(id)}"
      end
      
      def lock_prefix
        Base::DEFAULT_LOCK_PREFIX
      end
      
    end
    
    module InstanceMethods
      
      def lock(timeout = nil, &block)
        self.class.lock(self.id, timeout) or return false
        if block_given?
          self.class.do_locked_block(self.id, self.reload, &block)
        else
          true
        end
      end
      
      def unlock
        self.class.unlock(self.id)
      end
      
    end
  end
end