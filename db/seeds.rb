require 'factory_girl_rails'

Admin.create(email: "dave@rapin.com", name: "Dave Rapin")
Admin.create(email: "pweather24@gmail.com", name: "Paul Weatherhead")

420.times do
  Freelancer.create(
    email: Faker::Internet.unique.email,
    name: Faker::Name.unique.name
  )
end

240.times do
  Company.create(
    email: Faker::Internet.unique.email,
    name: Faker::Company.unique.name
  )
end

30.times do
  Project.create(
    company: Company.order(:name).first,
    external_project_id: Faker::Code.unique.isbn,
    name: Faker::Company.unique.name,
    budget: Faker::Commerce.price,
    starts_on: Faker::Date.unique.between(Date.today, 3.months.from_now),
    duration: Faker::Number.number(2)
  )
end
