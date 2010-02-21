require "test_helper"

class AttributesTest < ActiveSupport::TestCase
  
  def teardown
    Account.allow_settable_id!(false) # Leave pristine.
  end
  
  def test_attribute_type
    assert_equal :string, Account.attribute_type(:name)
  end
  
  def test_allow_settable_id
    assert_equal false, Account.allow_settable_id
    assert_raise(CurlyMustache::IdNotSettableError){ Account.create(:id => "123abc") }
    Account.allow_settable_id!
    assert_equal "123abc", Account.create(:id => "123abc").id
  end
  
  def test_attributes
    time = Time.now
    attributes = { :name => "test", :created_at => time, :updated_at => time }.stringify_keys
    account = Account.new
    account.attributes = attributes
    assert_equal attributes, account.attributes
  end
  
  def test_class_attributes
    assert_equal %w[id name phone_number balance is_admin created_at updated_at].sort, User.attributes.keys.sort
    assert_equal %w[id name created_at updated_at].sort, Account.attributes.keys.sort
    assert_equal :integer, User.attribute_type(:id)
    assert_equal :string, Account.attribute_type(:id)
  end
  
  def test_set_attributes
    assert_equal false, Account.allow_settable_id
    account = Account.new
    account.send(:set_attributes, :id => "123abc")
    assert_equal "123abc", account.id
  end
  
  def test_time_type
    time = Time.now
    account = Account.new
    
    account.created_at = time.to_s(:number)
    assert_equal Time.parse(time.to_s(:number)), account.created_at
    
    account.created_at = time.to_i
    assert_equal Time.at(time.to_i), account.created_at
    
    account.created_at = Object.new
    assert_equal nil, account.created_at
  end
  
  def test_set_to_nil
    user = User.new(:phone_number => 5123334444)
    assert_equal 5123334444, user.phone_number
    user.phone_number = nil
    assert_nil user.phone_number
    
    account = Account.new(:name => "blah")
    assert_equal "blah", account.name
    account.name = nil
    assert_equal "", account.name
  end
  
end