class UserSerializer < ActiveModel::Serializer
  attributes :name, :gender, :constituency_id
  has_one :constituency
  has_many :candidates
end
