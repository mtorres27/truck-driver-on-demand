require 'rails_helper'

describe Company::JobsController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }
  let(:job) { create(:job,
                     company: company,
                     address: 'Toronto',
                     state_province: 'ON',
                     country: 'ca',
                     state: 'created') }

  describe 'POST mark_as_finished' do
    let(:parameters) { { id: job.id } }
    let(:freelancer) { create :freelancer }

    it 'marks the job as finished' do
      post :mark_as_finished, params: parameters
      expect(job.reload.state).to eq('completed')
    end
  end
end
