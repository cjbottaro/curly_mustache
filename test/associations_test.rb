require File.dirname(__FILE__) + '/test_helper'

class Account < CurlyMustache::Base
  define_attributes do |attribute|
    attribute.define :name,       :string
    attribute.define :user_ids,   :array
  end
  
  association :users
end

class User < CurlyMustache::Base
  define_attributes do |attribute|
    attribute.define :account_id,   :integer
    attribute.define :name,         :string
  end
  
  association :account, :arity => :one
end

class AssociationsTest < Test::Unit::TestCase
  
  def test_one
    # set up some records
    Account.create! :id => 1, :name => "account"
    user = User.create! :id => 1, :account_id => 1, :name => "user"
    
    # test that the association loads
    assert(user.account)
    assert_equal("account", user.account.name)
    
    # test that we can set the association's attributes
    user.account.name = "tnuocca"
    assert_equal("tnuocca", user.account.name)
    
    # reload association
    assert_equal("account", user.account(true).name)
    
    # Assigning to the association should change our "foreign key" attribute.
    account2 = Account.create :id => 2, :name => "account2"
    user.account = account2
    assert_equal(account2, user.account)
    assert_equal(account2.id, user.account_id)
    
    # Assigning nil to the association should blank out our "foreign key" attribute.
    user.account = nil
    assert_equal(nil, user.account)
    assert_equal(nil, user.account_id)
  end
  
  def test_many
    # Set up some records.
    1.upto(5){ |i| User.create! :id => i }
    account = Account.create! :id => 1, :user_ids => [1, 2, 3]
    
    # Load the association, make sure it looks ok.
    assert(account.users.instance_of?(CurlyMustache::AssociationCollection))
    assert_equal 3, account.users.length
    assert_equal User.find(1, 2, 3), account.users.to_a
    
    # Add an item to the association.
    account.users << User.find(4)
    assert_equal 4, account.users.length
    assert_equal User.find(1, 2, 3, 4), account.users.to_a
    assert_equal [1, 2, 3, 4], account.user_ids
    
    # Make sure reloading works.
    old_name = account.users[0].name
    account.users[0].name = old_name.to_s + "blah"
    assert_equal(old_name, account.users(true)[0].name)
    
    # Set the association.
    account.users = User.find(1, 2, 3, 4)
    assert_equal 4, account.users.length
    assert_equal User.find(1, 2, 3, 4), account.users
    assert_equal [1, 2, 3, 4], account.user_ids
  end
  
end