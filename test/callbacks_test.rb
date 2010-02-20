require "test_helper"

class CallbacksTest < ActiveSupport::TestCase
  
  def test_callbacks
    Account.reset_callback_counts
    
    account = Account.create(:name => "blah")
    assert_equal 1, Account.callback_counts[:before_create]
    assert_equal 1, Account.callback_counts[:after_create]
    assert_equal 0, Account.callback_counts[:before_update]
    assert_equal 0, Account.callback_counts[:after_update]
    assert_equal 1, Account.callback_counts[:before_save]
    assert_equal 1, Account.callback_counts[:after_save]
    assert_equal 0, Account.callback_counts[:before_destroy]
    assert_equal 0, Account.callback_counts[:after_destroy]
    assert_equal 0, Account.callback_counts[:after_find]
    
    account.save
    assert_equal 1, Account.callback_counts[:before_create]
    assert_equal 1, Account.callback_counts[:after_create]
    assert_equal 1, Account.callback_counts[:before_update]
    assert_equal 1, Account.callback_counts[:after_update]
    assert_equal 2, Account.callback_counts[:before_save]
    assert_equal 2, Account.callback_counts[:after_save]
    assert_equal 0, Account.callback_counts[:before_destroy]
    assert_equal 0, Account.callback_counts[:after_destroy]
    assert_equal 0, Account.callback_counts[:after_find]
    
    account = Account.find(account.id)
    assert_equal 1, Account.callback_counts[:before_create]
    assert_equal 1, Account.callback_counts[:after_create]
    assert_equal 1, Account.callback_counts[:before_update]
    assert_equal 1, Account.callback_counts[:after_update]
    assert_equal 2, Account.callback_counts[:before_save]
    assert_equal 2, Account.callback_counts[:after_save]
    assert_equal 0, Account.callback_counts[:before_destroy]
    assert_equal 0, Account.callback_counts[:after_destroy]
    assert_equal 1, Account.callback_counts[:after_find]
    
    account.destroy
    assert_equal 1, Account.callback_counts[:before_create]
    assert_equal 1, Account.callback_counts[:after_create]
    assert_equal 1, Account.callback_counts[:before_update]
    assert_equal 1, Account.callback_counts[:after_update]
    assert_equal 2, Account.callback_counts[:before_save]
    assert_equal 2, Account.callback_counts[:after_save]
    assert_equal 1, Account.callback_counts[:before_destroy]
    assert_equal 1, Account.callback_counts[:after_destroy]
    assert_equal 1, Account.callback_counts[:after_find]
  end
  
end