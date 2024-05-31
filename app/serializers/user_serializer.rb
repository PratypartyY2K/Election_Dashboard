class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :gender, :constituency_id
  has_one :constituency
end
