require 'rails_helper'

describe Company::JobsController, type: :controller  do
  login_company
  let(:company) { subject.current_company }
  let(:job) { create(:job, project: create(:project, company: company), company: company, address: 'Toronto', state_province: 'ON', country: 'ca' ) }
  let(:freelancers) { double('Freelancers') }

  describe 'GET freelancer_matches' do
    let(:parameters) { { id: job.id } }

    before(:each) do
      allow(freelancers).to receive(:where).and_return(freelancers)
      allow(freelancers).to receive(:order).and_return(freelancers)
      allow(freelancers).to receive(:nearby).and_return(freelancers)
      allow(freelancers).to receive(:with_distance).and_return(freelancers)
      allow(Freelancer).to receive(:where).and_return(freelancers)
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
end
