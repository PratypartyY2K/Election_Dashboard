class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :gender, :constituency_id
end
