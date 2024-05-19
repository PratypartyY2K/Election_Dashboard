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

  # Indexes
  index({ party_id: 1 }, { unique: true, name: 'party_id_index' })

  # Method to fetch all candidates associated with the party
  def all_candidates
    Candidate.where(party_id: party_id)
  end
end
