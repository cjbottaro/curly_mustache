class Feed < CurlyMustache::Base
  attribute :title, :string
  attribute :url, :string
  
  serializer.in do |attributes|
    { "BLOB" => Marshal.dump(attributes) }
  end
  
  serializer.out do |data|
    Marshal.load(data["BLOB"])
  end
  
end