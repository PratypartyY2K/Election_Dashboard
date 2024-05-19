class PartySerializer < ActiveModel::Serializer
  attributes :party_id, :party
  has_many :candidates
  has_many :constituencies, through: :candidates
end
