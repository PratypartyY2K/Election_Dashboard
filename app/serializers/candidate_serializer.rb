class CandidateSerializer < ActiveModel::Serializer
  attributes :candidate_name, :age, :votes_obtained
  belongs_to :constituency
end
