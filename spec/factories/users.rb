FactoryBot.define do
  factory :user, class : "User" do
    # name { Faker::Name.name }
    # gender { %w[Male Female].sample }
    # constituency_id { rand(1..100) }
    name { "Test User" }
    gender { "Male" }
    constituency_id { 1 }
  end
end