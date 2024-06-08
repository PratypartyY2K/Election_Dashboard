require 'faker'
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    gender { %w[Male Female].sample }
    constituency_id { rand(1..100) }
  end
end