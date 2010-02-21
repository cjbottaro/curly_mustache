require "test_helper"

class ValidationsTest < ActiveSupport::TestCase
  
  def test_basic
    account = Account.new
    assert !account.valid?
    assert_equal 1, account.errors.length
    assert_equal ["can't be blank"], account.errors[:name]
  end
  
  def test_create
    account = Account.create
    assert account.new_record?
    assert_equal({}, account.attributes)
    assert_equal [:before_validation_on_create, :before_validation], account.callbacks_made
  end
  
  def test_create!
    begin
      Account.create!
      assert false
    rescue CurlyMustache::RecordInvalid => e
      assert e.message.index("Validation failed:") == 0
    end
  end
  
  def test_save
    account = Account.new
    assert_equal false, account.save
    assert_equal({}, account.attributes)
    assert_equal [:before_validation_on_create, :before_validation], account.callbacks_made
    
    # Now make sure the callback changed to on_update.
    account = Account.create!(:name => "blah")
    account.callbacks_made = []
    account.name = nil
    assert_equal false, account.save
    assert_equal [:before_validation_on_update, :before_validation], account.callbacks_made
  end
  
  def test_save!
    begin
      account = Account.new
      account.save!
      assert false
    rescue CurlyMustache::RecordInvalid => e
      assert e.message.index("Validation failed:") == 0
      assert_equal [:before_validation_on_create, :before_validation], account.callbacks_made
    end
    
    # Now make sure the callback changed to on_update.
    account = Account.create!(:name => "blah")
    account.callbacks_made = []
    begin
      account.name = nil
      account.save!
      assert false
    rescue CurlyMustache::RecordInvalid => e
      assert e.message.index("Validation failed:") == 0
      assert_equal [:before_validation_on_update, :before_validation], account.callbacks_made
    end
  end
  
end