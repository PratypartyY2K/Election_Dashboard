class Party
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Specify the custom collection name
  store_in collection: 'party_info', database: 'election_dashboard'
  
  # Fields
  field :party, type: String
  field :party_id, type: Integer

  # Associations
  has_many :candidates, class_name: 'Candidate'
  has_and_belongs_to_many :constituencies, class_name: 'Constituency'

  # Indexes
  # index({ party_id: 1 }, { unique: true, name: 'party_id_index' })

  # Method to fetch all candidates associated with the party
  def all_candidates
    Candidate.where(party_id: party_id)
  end

  # Method to fetch all constituencies associated with the party
  def all_constituencies
    Constituency.where(party_ids: party_id)
  end
end
