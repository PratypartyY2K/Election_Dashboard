class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Specify the custom collection name
  store_in collection: 'user_info', database: 'election_dashboard'

  # Fields
  field :name, type: String
  field :gender, type: String
  field :constituency_id, type: Integer
  validates :name, presence: true
  validates :gender, presence: true
  validates :constituency_id, presence: true

  # Associations
  has_one :constituency, class_name: 'Constituency', foreign_key: 'constituency_id'
end
