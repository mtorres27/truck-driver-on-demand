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

# Create some projects and attach them to a company
company = Company.order(:name).first
schools = ActiveSupport::JSON.decode(File.read('db/seeds/schools.json')).shuffle
schools.sample(20).each do |school|
  project = company.projects.create(
    external_project_id: Faker::Number.number(6),
    budget: Faker::Number.number(5),
    starts_on: Faker::Date.unique.between(Date.today, 3.months.from_now),
    duration: Faker::Number.number(2),
    name: school["name"],
    address: school["address"],
    area: "Toronto",
    closed: [true, false].sample
  )

  3.times do
    budget = Faker::Number.number(4)
    project.jobs.create(
      title: Faker::Educator.campus,
      summary: Faker::Lorem.paragraphs(2).join("\n\n"),
      budget: budget,
      job_function: Job.job_function.values.sample,
      starts_on: Faker::Date.unique.between(Date.today, 3.months.from_now),
      duration: Faker::Number.number(2),
      freelancer_type: Job.freelancer_type.values.sample,
      contract_price: (budget.to_f - Faker::Number.number(2).to_f),
      contract_paid: Faker::Number.number(3)
    )
  end
end
