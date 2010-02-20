require "curly_mustache/attributes/types"

types = CurlyMustache::Attributes::Types
types.define(:integer){ |value| Integer(value) rescue 0 }
types.define(:string){ |value| String(value) rescue "" }
types.define(:float){ |value| Float(value) rescue 0.0 }
types.define(:boolean){ |value| !!value }
types.define(:time) do |value|
  if value.kind_of?(Time)
    value
  elsif value.kind_of?(String)
    Time.parse(value)
  elsif value.kind_of?(Integer) or value.kind_of?(Float)
    Time.at(value)
  else
    nil
  end
end