require "test_helper"

class SerializationTest < ActiveSupport::TestCase
  
  def test_inheritance
    assert_equal     CurlyMustache::Base.serializer, User.serializer
    assert_equal     CurlyMustache::Base.serializer, Account.serializer
    assert_not_equal CurlyMustache::Base.serializer, Feed.serializer
  end
  
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
    
    page = Page.create(:url => "http://www.blah.com", :html => "<blah></blah>")
    assert_equal %w[GLOB],
                 Page.connection.get(Page.send(:id_to_key, page.id)).keys
  end
  
  # This is just for 100% code coverage.  The first time a serializer class is used,
  # it should be cached so we don't have to reinstantiate it.
  def test_caches_serializer_class
    page = Page.create(:url => "http://www.blah.com", :html => "<blah></blah>")
    Page.find(page.id)
  end
  
  # This is again for 100% code coverage
  def test_no_serializer
    begin
      Imbecile.create(:iq => 20)
      assert(false)
    rescue ArgumentError => e
      assert_equal "no class or block provided for serialization", e.message
    end
  end
  
end