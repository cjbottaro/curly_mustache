require File.dirname(__FILE__) + '/test_helper'

class User < CurlyMustache::Base
  define_attributes do |attribute|
    attribute.define :name,         :string
    attribute.define :phone_number, :integer
    attribute.define :balance,      :float
    attribute.define :is_admin,     :boolean
    attribute.define :created_at,   :datetime
    attribute.define :updated_at,   :time
  end
end

class CrudTest < Test::Unit::TestCase
  
  def setup
    CurlyMustache::Base.connection.flush_db
  end
  
  def attributes_hash
    { :id           => 123,
      :name         => "chris",
      :phone_number => 5128258325,
      :balance      => 1.01,
      :is_admin     => true,
      :created_at   => DateTime.parse("2009-04-23 22:09:50.936751 -05:00"),
      :updated_at   =>     Time.parse("2009-04-23 22:09:50.936751 -05:00") }.dup
  end
  
  def assert_attributes(record, attributes = nil)
    (attributes or attributes_hash).each do |k, v|
      assert_equal v, record.send(k), "for attribute '#{k}'"
    end
  end
  
  def test_create
    user = User.create(attributes_hash)
    assert(user)
    assert(!user.new_record?)
    user = User.find(attributes_hash[:id])
    assert_attributes(user)
  end
  
  def test_create!
    user = User.create!(attributes_hash)
    assert(user)
    assert(!user.new_record?)
    user = User.find(attributes_hash[:id])
    assert_attributes(user)
  end
  
  def test_create_autogen_id
    id = "1341adb122d8190872c2928dbcc08b9d"
    User.expects(:generate_id).returns(id)
    user = User.create :name => "christopher"
    assert_equal id, user.id
  end
  
  def test_find
    attributes1 = attributes_hash
    attributes1[:id] = 1
    User.create(attributes1)
    
    attributes2 = attributes_hash
    attributes2[:id] = 2
    User.create(attributes2)
    
    assert_equal User.find(1), User.find(1)
    
    user1 = User.find(1)
    assert_attributes(user1, attributes1)
    
    user2 = User.find(2)
    assert_attributes(user2, attributes2)
    
    assert_equal [user1, user2], User.find(1, 2)
    assert_raise(CurlyMustache::RecordNotFound){ User.find(3) }
    assert_raise(CurlyMustache::RecordNotFound){ User.find(1, 2, 3) }
  end
  
  def test_delete_all
    1.upto(3) do |i|
      attributes = attributes_hash
      attributes[:id] = i
      User.create(attributes)
    end
    
    User.delete_all(1, 2)
    assert_raise(CurlyMustache::RecordNotFound){ User.find(1) }
    assert_raise(CurlyMustache::RecordNotFound){ User.find(2) }
    assert(User.find(3))
  end
  
  def test_destroy_all
    1.upto(3) do |i|
      attributes = attributes_hash
      attributes[:id] = i
      User.create(attributes)
    end
    
    User.destroy_all(1, 2)
    assert_raise(CurlyMustache::RecordNotFound){ User.find(1) }
    assert_raise(CurlyMustache::RecordNotFound){ User.find(2) }
    assert(User.find(3))
  end
  
  def test_new
    user = User.new(attributes_hash)
    assert_attributes(user)
    assert(user.new_record?)
  end
  
  def test_reload
    user = User.new(attributes_hash)
    assert_raise(CurlyMustache::RecordNotFound){ user.reload }
    
    assert(user = User.create(attributes_hash))
    User.delete_all(user.id)
    assert_raise(CurlyMustache::RecordNotFound){ user.reload }
    
    assert(user = User.create(attributes_hash))
    user.name = "callie"
    assert_equal(user.read_attribute(:name), "callie")
    user.reload
    assert_equal(user.read_attribute(:name), attributes_hash[:name])
  end
  
  def test_save_by_expectations
    user = User.new(attributes_hash)
    user.expects(:create).once
    user.save
    
    user = User.create!(attributes_hash)
    user.expects(:update).once
    user.save
  end
  
  def test_save
    do_test_save(:save)
  end
  
  def test_save!
    do_test_save(:save!)
  end
  
  def test_destroy
    user = User.create!(attributes_hash)
    user.destroy
    assert(user.frozen?)
    assert_raise(CurlyMustache::RecordNotFound){ user.reload }
  end
  
  def do_test_save(method_name)
    user = User.new(attributes_hash)
    user.send(method_name)
    assert_attributes(user.reload)
    
    user = User.create!(attributes_hash)
    user.name = "callie"
    user.send(method_name)
    user.reload
    assert_equal("callie", user.name)
  end
  
end