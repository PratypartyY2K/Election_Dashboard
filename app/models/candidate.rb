class Candidate
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :constituency_id, type: Integer
  field :candidate_name, type: String
  field :sex, type: String
  field :votes_obtained, type: Integer
  field :position, type: Integer
  field :age, type: Integer
  field :candidate_type, type: String
  field :vote_share_percentage, type: Float
  field :party_id, type: Integer

  # Associations
  belongs_to :constituency, class_name: 'Constituency', foreign_key: 'constituency_id'
  belongs_to :party, class_name: 'Party', foreign_key: 'party_id'
end
