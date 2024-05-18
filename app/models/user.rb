class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String
  field :gender, type: String
  field :constituency_id, type: Integer

  # Associations
  belongs_to :constituency, class_name: 'Constituency', foreign_key: 'constituency_id'
end
