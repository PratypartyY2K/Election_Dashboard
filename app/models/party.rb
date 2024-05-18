class Party
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :party_abbreviation, type: String
  field :party_id, type: Integer

  # Associations
  has_many :candidate, class_name: 'Candidate'
end
