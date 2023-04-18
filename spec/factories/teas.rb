FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Tea.type }
    temperature { "180 degrees" }
    brew_time { Faker::Lorem.word }
  end
end