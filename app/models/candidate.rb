class Candidate
  include Mongoid::Document
  include Mongoid::Timestamps

  # Specify the custom collection name
  store_in collection: 'candidate_info', database: 'election_dashboard'

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

  # validations
  validates :candidate_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :sex, presence: true
  validates :age, presence: true, numericality: { only_integer: true }

  # Associations
  has_one :constituency, class_name: 'Constituency', foreign_key: :constituency_id
  has_one :party, class_name: 'Party', foreign_key: :party_id

  # Indexes
  index({ constituency_id: 1 })
  index({ party_id: 1 })

  # candidates having party_id
  def self.find_by_party(party_id)
    where(party_id:)
  end

  # candidates having constituency_id
  def self.find_by_constituency(constituency_id)
    where(constituency_id:)
  end

  # find sum of all votes obtained by all the candidates combined
  def self.total_votes_obtained(filters = {})
    pipeline = [
      { '$match' => filters },
      { '$group' => {
        _id: nil,
        totalVotes: { "$sum": '$votes_obtained' }
      } }
    ]

    result = collection.aggregate(pipeline).first
    result ? result['totalVotes'] : 0
  end
end
