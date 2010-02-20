class Imbecile < CurlyMustache::Base
  attribute :iq, :integer
  
  serializer.in
  serializer.out
end