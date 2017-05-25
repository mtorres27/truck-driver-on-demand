require 'factory_girl_rails'

Admin.create!(email: "dave@rapin.com", name: "Dave Rapin")
Admin.create!(email: "pweather24@gmail.com", name: "Paul Weatherhead")

420.times do
  Freelancer.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Name.unique.name,
    area: Faker::Address.city,
    tagline: Faker::Company.catch_phrase
  )
end

240.times do
  Company.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Company.unique.name
  )
end

# Create some projects and attach them to a company
company = Company.order(:name).first
schools = ActiveSupport::JSON.decode(File.read('db/seeds/schools.json')).shuffle
schools.sample(20).each do |school|
  project = company.projects.create!(
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
    job = project.jobs.create!(
      title: Faker::Educator.campus,
      summary: Faker::Lorem.paragraphs(2).join("\n\n"),
      budget: budget,
      job_function: Job.job_function.values.sample,
      starts_on: Faker::Date.unique.between(Date.today, 3.months.from_now),
      duration: Faker::Number.number(2),
      freelancer_type: Job.freelancer_type.values.sample,
      state: Job.state.values.sample
    )

    5.times do
      begin
        applicant = job.applicants.create!(
          freelancer: Freelancer.order("RANDOM()").first,
          state: Applicant.state.values.select{ |v| v != :accepted }.sample
        )
        applicant.quotes.create!(
          amount: [(budget.to_f - Faker::Number.number(2).to_f), (budget.to_f + Faker::Number.number(2).to_f)].sample,
          rejected: true
        )
      rescue Exception => e
        puts e
        # do nothing, this is just in case we get the exact same freelancer more than once
      end
    end

    applicant = job.applicants.order(created_at: :desc).first
    applicant.update_column(:state, "accepted")
    quote = applicant.quotes.order(created_at: :desc).first
    quote.update_column(:rejected, false)
    job.update_column(:contract_price, quote.amount)
    4.times do
      job.messages.create!(authorable: applicant.freelancer, body: Faker::ChuckNorris.fact)
    end
  end
end
