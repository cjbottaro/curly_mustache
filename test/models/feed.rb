class Feed < CurlyMustache::Base
  attribute :title, :string
  attribute :url, :string
  
  def send_attributes(attributes)
    { "BLOB" => Marshal.dump(attributes) }
  end
  
  def recv_attributes(attributes)
    Marshal.load(attributes["BLOB"])
  end
  
end