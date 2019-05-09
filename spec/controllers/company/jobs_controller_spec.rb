require 'rails_helper'

describe Company::JobsController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }
  let(:job) { create(:job,
                     company: company,
                     address: 'Toronto',
                     state_province: 'ON',
                     country: 'ca',
                     job_type: 'system_integration',
                     job_market: 'type',
                     job_function: 'type',
                     starts_on: Date.today,
                     scope_of_work: 'Scope',
                     pay_type: 'fixed',
                     state: 'created',
                     creator: company.owner) }

  describe 'POST mark_as_finished' do
    let(:parameters) { { id: job.id } }
    let(:freelancer) { create :freelancer }

    before(:each) do
      allow_any_instance_of(Job).to receive(:freelancer).and_return(freelancer)
    end

    it 'marks the job as finished' do
      post :mark_as_finished, params: parameters
      expect(job.reload.state).to eq('completed')
    end

    it 'sends email to freelancer and company' do
      expect { post :mark_as_finished, params: parameters }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end

    it 'sends notification to company and freelancer' do
      expect { post :mark_as_finished, params: parameters }.to change { Notification.count }.by(1)
    end
  end
end
