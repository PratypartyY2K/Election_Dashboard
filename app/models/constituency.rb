class Constituency
  include Mongoid::Document
  include Mongoid::Timestamps

  # Specify the custom collection name
  store_in collection: 'constituency_info', database: 'election_dashboard'

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

  # Indexes
  index({ constituency_id: 1 }, { unique: true, name: 'constituency_id_index' })

  def self.distinct_party_count(constituency_id)
    Candidate.collection.aggregate([
                                     { "$match": { "constituency_id": constituency_id } },
                                     { "$group": { "_id": '$party_id' } },
                                     { "$count": 'distinct_party_count' }
                                   ]).first['distinct_party_count'] || 0
  end

  # find sum of all voters present in the table
  def self.voter_count_filtered(filters = {})
    pipeline = [
      { '$match' => filters },
      { '$group' => {
        _id: nil,
        totalVoters: { "$sum": '$voters' }
      } }
    ]

    result = collection.aggregate(pipeline).first
    result ? result['totalVoters'] : 0
  end

  # find sum of all votes obtained by all the candidates combined
  def self.candidate_count_filtered(filters = {})
    pipeline = [
      { '$match' => filters },
      { '$group' => {
        _id: nil,
        totalCandidateCount: { "$sum": '$candidate_count' }
      } }
    ]

    result = collection.aggregate(pipeline).first
    result ? result['totalCandidateCount'] : 0
  end
end
