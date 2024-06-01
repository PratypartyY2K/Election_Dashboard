class CandidateSerializer < ActiveModel::Serializer
  attributes :constituency_id, :position, :candidate_name, :sex, :votes_obtained, :age, :candidate_type, :vote_share_percentage, :party_id
  has_one :constituency, :party
end
