Company.create(
  email: "pweather24@gmail.com",
  name: "Paul's AV Company",
  contact_name: "Paul Weatherhead",
  address: "2010 Winston Park Drive, Suite 200, Oakville, ON, L6H 6P5",
  avatar: File.new(Rails.root.join("app", "assets", "images", "avjunction-logo_header.svg")),
  password: "654321", 
  password_confirmation: "654321"
).tap do |company|

  # Project 1
  company.projects.create(
    external_project_id: 800600,
    budget: 5000,
    starts_on: Date.parse("2017-09-07"),
    duration: 10,
    name: "Executive Boardroom",
    address: "5333 Westheimer Rd #1000, Houston, TX 77056, USA",
    area: "Texas",
    closed: false
  ).tap do |project|

    project.jobs.create(
      company: company,
      title: "AV Tech required for boardroom install",
      budget: 3000,
      contract_price: 2900,
      summary: "Require an experienced AV installation technician to work alongside internal company technician (acting onsite project manager) to install various AV equipment for an executive boardroom.  Equipment consists of 90” Display wall mounted at front of the room, ceiling mounted speakers, polycom trio video conferencing system, under table mounted rack and basic crestron control.",
      job_function: :av_installation_technician,
      starts_on: Date.parse("2017-09-07"),
      duration: 10,
      pay_type: :fixed,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 500,
          issued_on: 7.days.ago,
          paid_on: 6.days.ago
        )
        job.payments.create(
          company: company,
          description: "First Installment",
          amount: 1000,
          issued_on: 5.days.ago,
          paid_on: 4.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 1400,
          issued_on: 1.days.ago
        )
      end
   end

   project.jobs.create(
      company: company,
      title: "Crestron Programmer required for boardroom install",
      budget: 2000,
      contract_price: 1900,
      summary: "Require an experienced crestron programmer to create code and touch screen gui for control of audio visual equipment for an executive boardroom.  Equipment to be controlled consists of 90” Display, speakers, biamp amplifier and polycom trio video conferencing system.  Basic control required in this room.\n\n***Onsite programing and loading of code not required. Company has personnel to load code on site.  Candidate should be available via phone for support if necessary during the code loading.",
      job_function: :av_programmer,
      starts_on: Date.parse("2017-09-13"),
      duration: 4,
      pay_type: :fixed,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 200,
          issued_on: 8.days.ago,
          paid_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "First Installment",
          amount: 800,
          issued_on: 4.days.ago,
          paid_on: 3.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 900,
          issued_on: 2.days.ago
        )
      end
    end
  end


  # Project 2
  company.projects.create(
    name: "Atrium 5x5 Videowall - Digital Signage Project",
    external_project_id: 800601,
    budget: 6000,
    address: "1754 Technology Dr #135, San Jose, CA 95110, USA",
    area: "San Jose",
    starts_on: Date.parse("2017-09-19"),
    duration: 7,
    closed: false
  ).tap do |project|

    project.jobs.create(
      company: company,
      title: "Video wall specialist required.",
      budget: 4000,
      contract_price: 3800,
      summary: "Require an experienced AV installation technician to work alongside internal company technician (acting onsite project manager) to install videowall in end clients atrium.  NEC 46\" LCD videowall panels with pull out chief mounts",
      job_function: :av_installation_technician,
      starts_on: Date.parse("2017-09-19"),
      duration: 7,
      pay_type: :fixed,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 500,
          issued_on: 7.days.ago,
          paid_on: 6.days.ago
        )
        job.payments.create(
          company: company,
          description: "First Installment",
          amount: 2000,
          issued_on: 5.days.ago,
          paid_on: 4.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 1300,
          issued_on: 1.days.ago
        )
      end
   end

   project.jobs.create(
      company: company,
      title: "Extron Programmer required control of videowall",
      budget: 2000,
      contract_price: 1900,
      summary: "Require an experienced crestron programmer to create code and touch screen gui for control of audio visual equipment for a video wall in atrium for end client.  Equipment to be controlled consists of 5x5 configuation of NEC 46\" displays and green hippo vw processor.",
      job_function: :av_programmer,
      starts_on: Date.parse("2017-09-26"),
      duration: 3,
      pay_type: :fixed,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 1000,
          issued_on: 8.days.ago,
          paid_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 900,
          issued_on: 2.days.ago
        )
      end
    end
  end


  # #########
  # Project 3
  company.projects.create(
    name: "Broadcast Studio - LED installation",
    external_project_id: 800602,
    budget: 10000,
    address: "366 Adelaide Street East #230, Toronto, ON M5A 3X9",
    area: "Toronto",
    starts_on: Date.parse("2017-10-04"),
    duration: 15,
    closed: false
  ).tap do |project|

    project.jobs.create(
      company: company,
      title: "AV Technician required. General Labor",
      budget: 2000,
      contract_price: 1800,
      summary: "Lorem ipsum",
      job_function: :av_installation_technician,
      starts_on: Date.parse("2017-10-04"),
      duration: 15,
      pay_type: :hourly,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 900,
          issued_on: 7.days.ago,
          paid_on: 6.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 900,
          issued_on: 1.days.ago
        )
      end
   end

   project.jobs.create(
      company: company,
      title: "3 AV technicians required. Broadcast and videowall experience",
      budget: 8000,
      contract_price: 7000,
      summary: "Lorem ipsum",
      job_function: :av_installation_technician,
      starts_on: Date.parse("2017-10-04"),
      duration: 15,
      pay_type: :hourly,
      freelancer_type: :av_labor_company,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 4500,
          issued_on: 8.days.ago,
          paid_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 3000,
          issued_on: 2.days.ago
        )
      end
    end
  end


  # #########
  # Project 4
  company.projects.create(
    name: "University New AV Build - 40 Classrooms (2 room types)",
    external_project_id: 800603,
    budget: 9000,
    address: "University of Cambridge, Downing Pl, Cambridge CB2 3EN, UK",
    area: "Cambridge",
    starts_on: Date.parse("2017-10-16"),
    duration: 20,
    closed: false
  ).tap do |project|

    project.jobs.create(
      company: company,
      title: "4 AV technician required. Broadcast and videowall experience",
      budget: 7500,
      contract_price: 7500,
      summary: "Lorem ipsum",
      job_function: :av_installation_technician,
      starts_on: Date.parse("2017-10-16"),
      duration: 20,
      pay_type: :hourly,
      freelancer_type: :av_labor_company,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      )
   end

   project.jobs.create(
      company: company,
      title: "AV Programmer required.",
      budget: 1500,
      contract_price: 1200,
      summary: "Lorem ipsum",
      job_function: :av_programmer,
      starts_on: Date.parse("2017-10-30"),
      duration: 5,
      pay_type: :hourly,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 500,
          issued_on: 8.days.ago,
          paid_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 700,
          issued_on: 2.days.ago
        )
      end
    end
  end


  # #########
  # Project 5
  company.projects.create(
    name: "Retail Digital Signage Project",
    external_project_id: 800604,
    budget: 5500,
    address: "151 W 34th St, New York, NY 10001, USA",
    area: "New York",
    starts_on: Date.parse("2017-09-21"),
    duration: 7,
    closed: false
  ).tap do |project|

    project.jobs.create(
      company: company,
      title: "2 AV Technicians required. Digital signage and VW experience.",
      budget: 4000,
      contract_price: 4000,
      summary: "Lorem ipsum",
      job_function: :av_installation_technician,
      starts_on: Date.parse("2017-10-16"),
      duration: 20,
      pay_type: :hourly,
      freelancer_type: :av_labor_company,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 1200,
          issued_on: 8.days.ago,
          paid_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 2800,
          issued_on: 2.days.ago
        )
      end
   end

   project.jobs.create(
      company: company,
      title: "AV Programmer required.",
      budget: 1500,
      contract_price: 1200,
      summary: "Lorem ipsum",
      job_function: :av_programmer,
      starts_on: Date.parse("2017-10-30"),
      duration: 5,
      pay_type: :hourly,
      freelancer_type: :independent,
      state: :contracted
    ).tap do |job|

      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: :accepted
      ).tap do |applicant|

        job.payments.create(
          company: company,
          description: "Deposit",
          amount: 500,
          issued_on: 8.days.ago,
          paid_on: 5.days.ago
        )
        job.payments.create(
          company: company,
          description: "Final Payment",
          amount: 700,
          issued_on: 2.days.ago
        )
      end
    end
  end



  # ####
  # Standard filler
  company.jobs.each do |job|

    4.times do |idx|
      job.messages.create!(
        authorable: job.applicants.first.freelancer,
        body: Faker::ChuckNorris.fact,
        attachment: File.new(Rails.root.join("creative", "messages", "#{idx + 1}.png"))
      )
      job.messages.create!(
        authorable: job.company,
        body: Faker::Company.catch_phrase
      )
    end

    3.times do
      job.applicants.create(
        company: company,
        freelancer: Freelancer.order("RANDOM()").first,
        state: Applicant.state.values.select{ |v| v != :accepted }.sample
      ) rescue nil
    end
  end
end
