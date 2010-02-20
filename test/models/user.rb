class User < CurlyMustache::Base
  allow_settable_id!
  attribute :id,           :integer
  attribute :name,         :string
  attribute :phone_number, :integer
  attribute :balance,      :float
  attribute :is_admin,     :boolean
  attribute :created_at,   :time
  attribute :updated_at,   :time
end