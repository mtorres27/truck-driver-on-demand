require 'rails_helper'

describe Company::FreelancersController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }
  let(:job) { create(:job, project: create(:project, company: company), company: company, address: 'Toronto', state_province: 'ON', country: 'ca', state: 'published' ) }
  let(:freelancer) { create(:freelancer) }

  describe "GET #invite_to_quote" do

    it "sends a notification to the freelancer" do
      expect { get :invite_to_quote, params: { id: freelancer.id, job_to_invite: job.id } }.to change { Notification.count }.by(1)
    end

    it "sends an email" do
      expect { get :invite_to_quote, params: { id: freelancer.id, job_to_invite: job.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "creates a job_invite" do
      expect { get :invite_to_quote, params: { id: freelancer.id, job_to_invite: job.id } }.to change { JobInvite.count }.by(1)
    end

  end
end
