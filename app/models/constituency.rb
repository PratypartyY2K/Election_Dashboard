class Constituency
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :constituency_id, type: Integer
  field :valid_votes, type: Integer
  field :voters, type: Integer
  field :constituency_name, type: String
  field :constituency_type, type: String
  field :district_name, type: String
  field :sub_region, type: String
  field :candidate_count, type: Integer
  field :turnout_percentage, type: Float

  # Associations
  has_many :candidates, class_name: 'Candidate'
  has_many :users, class_name: 'User'
end
