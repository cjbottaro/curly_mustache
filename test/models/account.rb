class Account < CurlyMustache::Base
  attribute :name, :string
  attribute :created_at, :time
  attribute :updated_at, :time
end