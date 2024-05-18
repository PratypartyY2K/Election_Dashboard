class UserSerializer < ActiveModel::Serializer
  attributes :name, :gender, :constituency_id
  belongs_to :constituency
end
