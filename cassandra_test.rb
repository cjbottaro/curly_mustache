require "curly_mustache"
require "/Users/cjbottaro/Work/klondike/qanat/lib/protobuf/CrawlerMessages.pb"
require "/Users/cjbottaro/Work/klondike/qanat/lib/protobuf/message"
require "/Users/cjbottaro/Work/klondike/qanat/lib/protobuf/proto"

class UrlInfo < CurlyMustache::Base
  establish_connection :adapter => "cassandra",
                       :server => "localhost:9160",
                       :keyspace => "Onespot"
  
  attribute :fetch_url, :string
  attribute :canonical_url, :string
  
  serializer.in do |hash|
    hash.inject({}) do |memo, (k, v)|
      if User.attribute_type(k) == :time
        memo[k] = v.to_s(:number)
      else
        memo[k] = String(v)
      end
      memo
    end
  end
  
  serializer.out do |hash|
    url_info = Proto::Com.parse_from_string(hash["BLOB"])
    { :fetch_url => url_info.fetch_url,
      :canonical_url => url_info.canonical_url }
  end
end