require 'factory_girl_rails'

Admin.create(email: "dave@rapin.com", name: "Dave Rapin")
Admin.create(email: "pweather24@gmail.com", name: "Paul Weatherhead")

10.times do
  Freelancer.create(
    email: Faker::Internet.unique.email,
    name: Faker::Name.unique.name
  )
end

10.times do
  Company.create(
    email: Faker::Internet.unique.email,
    name: Faker::Company.unique.name,
    tagline: Faker::Company.catch_phrase
  )
end
