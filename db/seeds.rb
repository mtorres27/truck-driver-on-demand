require 'factory_girl_rails'

10.times { FactoryGirl.create :freelancer }

10.times do
  FactoryGirl.create(
    :company,
    tagline: Faker::Company.catch_phrase
  )
end
