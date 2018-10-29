FactoryBot.define do
  factory :idea do
    association(:user, factory: :user)
    title { Faker::Lorem.question }
    description { Faker::Lorem.sentences(rand(2..6)).join(" ") }
  end
end
