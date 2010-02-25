require "test_helper"

class SerializationTest < ActiveSupport::TestCase
  
  def test_basic
    feed = Feed.create(:title => "blah", :url => "http://www.blah.com")
    feed = Feed.find(feed.id)
    assert_equal "blah", feed.title
    assert_equal "http://www.blah.com", feed.url
  end
  
  def test_proper_connection
    feed = Feed.create(:title => "blah", :url => "http://www.blah.com")
    assert_equal %w[BLOB],
                 Feed.connection.get(Feed.send(:id_to_key, feed.id)).keys
    
    account = Account.create(:name => "blah", :created_at => Time.now, :updated_at => Time.now)
    assert_equal %w[id name created_at updated_at].sort,
                 Account.connection.get(Account.send(:id_to_key, account.id)).keys.sort
  end
  
end