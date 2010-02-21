require "test_helper"

class BadAdapter < CurlyMustache::Adapters::Abstract; end

class AbstractAdapterTest < ActiveSupport::TestCase
  
  def test_not_implemented
    assert_raise(CurlyMustache::NotImplementedError){ BadAdapter.new(nil) }
    BadAdapter.class_eval do
      def read_config(config); nil; end
    end
    adapter = BadAdapter.new(nil)
    assert_raise(CurlyMustache::NotImplementedError){ adapter.get(1) }
    assert_raise(CurlyMustache::NotImplementedError){ adapter.mget([1, 2]) }
    assert_raise(CurlyMustache::NotImplementedError){ adapter.put(1, "one") }
    assert_raise(CurlyMustache::NotImplementedError){ adapter.delete(1) }
    assert_raise(CurlyMustache::NotImplementedError){ adapter.flush_db }
    assert_raise(CurlyMustache::NotImplementedError){ adapter.lock(1) }
    assert_raise(CurlyMustache::NotImplementedError){ adapter.unlock(1) }
  end
  
end