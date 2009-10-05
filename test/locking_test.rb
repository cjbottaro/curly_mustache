require "test_helper"

class User < CurlyMustache::Base
  attribute :name, :string
end

class LockingTest < Test::Unit::TestCase
  
  def setup
    CurlyMustache::Base.connection.flush_db
    @user = User.create! :name => "chris"
  end
  
  def test_lock_unlock
    assert !@user.unlock
    assert  @user.lock
    assert !@user.lock
    assert  @user.unlock
  end
  
  def test_lock_with_block
    assert_equal "chris", @user.lock{ |user| user.name }
    assert_equal true, @user.lock
    assert_equal false, @user.lock{ |user| user.name }
    assert_equal true, @user.unlock
    @user.lock{ raise "blah" } rescue nil
    assert_equal false, @user.unlock
  end
  
  def test_lock_with_timeout
    assert_equal true, @user.lock
    assert_raise(Timeout::Error){ @user.lock(0.1) }
    assert_equal true, @user.unlock
    assert_equal "chris", @user.lock(0.1){ |user| user.name }
    assert_equal false, @user.unlock
  end
  
  def test_lock_and_find
    assert_equal true, @user.lock
    assert_equal false, User.lock_and_find(@user.id)
    assert_raise(Timeout::Error){ User.lock_and_find(@user.id, 0.1) }
    assert_equal true, @user.unlock
    assert_equal "chris", User.lock_and_find(@user.id).name
    assert_equal true, @user.unlock
    assert_equal "chris", User.lock_and_find(@user.id){ |user| user.name }
    assert_equal false, @user.unlock
  end
  
end