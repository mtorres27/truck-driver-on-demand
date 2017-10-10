require 'factory_girl_rails'

ApplicationRecord.descendants.each do |klass|
  klass.auditing_enabled = false
end

Admin.create!(email: "dave@rapin.com", name: "Dave Rapin", password: "654321", password_confirmation: "654321")
Admin.create!(email: "pweather24@gmail.com", name: "Paul Weatherhead", password: "654321", password_confirmation: "654321")

420.times do
  Freelancer.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Name.unique.name,
    area: Faker::Address.city,
    tagline: Faker::Company.catch_phrase,
    password: "654321", 
    password_confirmation: "654321"
  )
end

require Rails.root.join("db/seeds/realistic.rb")

240.times do
  Company.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Company.unique.name,
    password: "654321", 
    password_confirmation: "654321"
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
      company: company,
      title: "#{Faker::Address.city} #{%w(Unit Campus Building Block Room Floor Section Mazzanine Landing Basement).sample}",
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
          company: company,
          freelancer: Freelancer.order("RANDOM()").first,
          state: Applicant.state.values.select{ |v| v != :accepted }.sample
        )
        quote = applicant.quotes.new(
          company: company,
          pay_type: Quote.pay_type.values.sample,
          state: "declined"
        )
        quote.amount =
          if quote.fixed?
            [(budget.to_f - Faker::Number.number(2).to_f), (budget.to_f + Faker::Number.number(2).to_f)].sample
          else
            Faker::Number.number(2).to_f
          end
        quote.save
      rescue Exception => e
        puts e
        # do nothing, this is just in case we get the exact same freelancer more than once
      end
    end

    unless job.pre_negotiated?
      applicant = job.applicants.first
      if applicant
        quote = applicant.quotes.order(created_at: :desc).first
        applicant.update_columns(state: "accepted")
        quote.update_columns(state: "accepted")
        job.update_columns(contract_price: quote.amount, pay_type: quote.pay_type)
        4.times do |idx|
          job.messages.create!(
            authorable: applicant.freelancer,
            body: Faker::ChuckNorris.fact,
            attachment: File.new(Rails.root.join("creative", "messages", "#{idx + 1}.png"))
          )
          job.messages.create!(
            authorable: job.company,
            body: Faker::Company.catch_phrase
          )
        end
        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 200,
          issued_on: 7.days.ago,
          paid_on: 6.days.ago
        )
        job.payments.create(
          company: company,
          description: "First Installment",
          amount: 1620,
          issued_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 2200,
          issued_on: 3.days.ago
        )
      end
    end
  end
end
