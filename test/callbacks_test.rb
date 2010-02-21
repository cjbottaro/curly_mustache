require "test_helper"

class CallbacksTest < ActiveSupport::TestCase
  
  def test_callbacks
    account = Account.create(:name => "blah")
    assert_equal [:before_validation_on_create, :before_validation, :after_validation, :after_validation_on_create, :before_create, :before_save, :after_save, :after_create], account.callbacks_made
    
    account.callbacks_made = []
    account.save
    assert_equal [:before_validation_on_update, :before_validation, :after_validation, :after_validation_on_update, :before_update, :before_save, :after_save, :after_update], account.callbacks_made
    
    account.callbacks_made = []
    account = Account.find(account.id)
    assert_equal [:after_find], account.callbacks_made
    
    account.callbacks_made = []
    account.destroy
    assert_equal [:before_destroy, :after_destroy], account.callbacks_made
  end
  
end