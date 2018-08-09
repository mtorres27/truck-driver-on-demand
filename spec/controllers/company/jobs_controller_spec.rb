require 'rails_helper'

describe Company::JobsController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }
  let(:job) { create(:job, project: create(:project, company: company), company: company, address: 'Toronto', state_province: 'ON', country: 'ca' ) }

  describe 'GET freelancer_matches' do
    let(:freelancers) { double('Freelancers') }
    let(:parameters) { { id: job.id } }
    let(:geocode) { { address: "Toronto, ON, Canada", lat: 43.653226, lng: -79.3831843 } }

    before(:each) do
      allow(Rails).to receive_message_chain(:cache, :read).and_return(geocode)
      allow(Freelancer).to receive(:where).and_return(freelancers)
      allow(freelancers).to receive(:where).and_return(freelancers)
      allow(freelancers).to receive(:order).and_return(freelancers)
      allow(freelancers).to receive(:nearby).and_return(freelancers)
      allow(freelancers).to receive(:with_distance).and_return(freelancers)
      allow(freelancers).to receive(:map).and_return(1)
      allow(freelancers).to receive(:to_i).and_return(freelancers)
    end

    it 'defines @freelancers' do
      get :freelancer_matches, params: parameters
      expect(assigns(:freelancers)).to be_present
    end

    it 'defines @address_for_geocode' do
      get :freelancer_matches, params: parameters
      expect(assigns(:address_for_geocode)).to eq('Toronto, Ontario, Canada')
    end

    it 'defines @geocode' do
      get :freelancer_matches, params: parameters
      expect(assigns(:geocode)).to be_present
    end

    context 'when distance is present' do
      let(:parameters) { { id: job.id, search: { distance: '160000' } } }

      it 'defines @distance' do
        get :freelancer_matches, params: parameters
        expect(assigns(:distance)).to eq('160000')
      end
    end
  end

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
  end
end
