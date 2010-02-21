require "test_helper"

unless [:cassandra].include?(CurlyMustache::Base.connection.adapter)
  require "curly_mustache/locking"
  CurlyMustache::Base.send(:include, CurlyMustache::Locking)
end

class LockingTest < ActiveSupport::TestCase
  
  def setup
    if CurlyMustache::Base.method_defined?(:lock)
      CurlyMustache::Base.connection.flush_db
      @account = Account.create :name => "chris"
    else
      disable_tests
    end
  end
  
  def test_lock_unlock
    assert !@account.unlock
    assert  @account.lock
    assert !@account.lock
    assert  @account.unlock
  end
  
  def test_lock_with_block
    assert_equal "chris", @account.lock{ |user| user.name }
    assert_equal false, @account.locked?
    assert_equal true, @account.lock
    assert_equal false, @account.lock{ |user| user.name }
    assert_equal true, @account.locked?
    assert_equal true, @account.unlock
    assert_equal false, @account.locked?
    @account.lock{ raise "blah" } rescue nil
    assert_equal false, @account.locked?
  end
  
  def test_lock_with_timeout
    assert_equal true, @account.lock
    assert_raise(Timeout::Error){ @account.lock(0.1) }
    assert_equal true, @account.unlock
    assert_equal "chris", @account.lock(0.1){ |user| user.name }
    assert_equal false, @account.unlock
  end
  
  def test_lock_and_find
    assert_equal true, @account.lock
    assert_equal false, Account.lock_and_find(@account.id)
    assert_raise(Timeout::Error){ Account.lock_and_find(@account.id, 0.1) }
    assert_equal true, @account.unlock
    assert_equal "chris", Account.lock_and_find(@account.id).name
    assert_equal true, @account.unlock
    assert_equal "chris", Account.lock_and_find(@account.id){ |user| user.name }
    assert_equal false, @account.unlock
  end
  
end