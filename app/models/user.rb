class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Specify the custom collection name
  store_in collection: 'user_info', database: 'election_dashboard'

  # Fields
  field :name, type: String
  field :gender, type: String
  field :constituency_id, type: Integer

  # validations
  validates :name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :gender, presence: true
  validates :constituency_id, presence: true

  # Associations
  has_one :constituency, class_name: 'Constituency', foreign_key: 'constituency_id'
end
