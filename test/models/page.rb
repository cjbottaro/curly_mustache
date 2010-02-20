class PageSerializer
  def in(attributes)
    { "GLOB" => Marshal.dump(attributes) }
  end
  def out(data)
    Marshal.load(data["GLOB"])
  end
end

class Page < CurlyMustache::Base
  attribute :url, :string
  attribute :html, :string
  
  serializer.in  :page_serializer
  serializer.out :page_serializer
end