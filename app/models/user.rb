class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Specify the custom collection name
  store_in collection: 'user_info', database: 'election_dashboard'

  # Fields
  field :name, type: String
  field :gender, type: String
  field :constituency_id, type: Integer

  # Associations
  belongs_to :constituency, class_name: 'Constituency', foreign_key: 'constituency_id'

  # Method to fetch all candidates associated with the party
  def belongs_to_constituency
    Constituency.where(constituency_id: constituency_id)
  end
end
