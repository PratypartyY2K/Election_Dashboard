class Party
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Specify the custom collection name
  store_in collection: 'party_info', database: 'election_dashboard'
  
  # Fields
  field :party_abbreviation, type: String
  field :party_id, type: Integer

  # Associations
  has_many :candidate, class_name: 'Candidate'
end
