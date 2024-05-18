class ConstituencySerializer < ActiveModel::Serializer
  attributes :constituency_id, :constituency_name, :voters
  has_many :users
end
