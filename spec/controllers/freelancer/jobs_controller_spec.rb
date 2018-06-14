require 'rails_helper'

describe Freelancer::JobsController, type: :controller  do
  describe 'GET index' do
    login_freelancer

    context 'when search criteria is empty' do
      it 'displays an error message' do
        get :index
        expect(flash[:error]).to be_present
      end

      it 'redirects to freelancer_root_path' do
        get :index
        expect(response).to redirect_to(freelancer_root_path)
      end
    end

    context 'when search criteria is not empty' do

      context 'when keywords exists' do
        it 'sets @keywords' do
          get :index, params: { search: { keywords: 'Keywords' } }
          expect(assigns(:keywords)).to eq('Keywords')
        end
      end

      context 'when address exists' do
        before(:each) do
          get :index, params: { search: { address: 'Toronto, Ontario' } }
          allow(Rails).to receive(:cache).and_return(double('Readable', read: true))
        end

        it 'sets @address' do
          expect(assigns(:address)).to eq('Toronto, Ontario')
        end

        it 'sets @geocode' do
          expect(assigns(:geocode)).to be_present
        end
      end

      context 'when country exists' do
        before(:each) do
          get :index, params: { search: { country: 'Country' } }
        end
        it 'sets @country' do
          expect(assigns(:country)).to eq('Country')
        end
      end

      context 'when state_province exists' do
        before(:each) do
          get :index, params: { search: { country: 'Country', state_province: 'State' } }
        end
        it 'sets @country' do
          expect(assigns(:country)).to eq('Country')
        end
        it 'sets @state_province' do
          expect(assigns(:state_province)).to eq('State')
        end
      end

      context 'when sort exists' do
        before(:each) do
          get :index, params: { search: { sort: 'Sort' } }
        end
        it 'sets @sort' do
          expect(assigns(:sort)).to eq('Sort')
        end
      end

      context 'when distance exists' do
        before(:each) do
          get :index, params: { search: { distance: 'Distance' } }
        end
        it 'sets @distance' do
          expect(assigns(:distance)).to eq('Distance')
        end
      end
    end
  end

  describe 'GET job matches' do
    login_freelancer
    
    let(:freelancer) { subject.current_user }
    let(:jobs) { double("jobs") }

    before(:each) do
      freelancer.freelancer_profile.update_attribute(:job_types, { 'system_integration' => '1' })
      freelancer.freelancer_profile.update_attribute(:city, 'Toronto')
      freelancer.freelancer_profile.update_attribute(:state, 'ON')
      freelancer.freelancer_profile.update_attribute(:country, 'ca')
      allow(jobs).to receive(:with_distance).and_return(jobs)
      allow(Job).to receive(:none).and_return(jobs)
      allow(jobs).to receive(:or).and_return(jobs)
      allow(jobs).to receive(:nearby).and_return(jobs)
      allow(jobs).to receive(:with_distance).and_return(jobs)
      allow(jobs).to receive(:order).and_return(jobs)
      allow(jobs).to receive(:page).and_return(jobs)
      allow(jobs).to receive(:per).and_return(jobs)
    end

    context 'when job matches exists' do
      it 'sets @jobs' do
        get :job_matches
        expect(assigns(:jobs)).to be_present
      end

      it 'sets @address' do
        get :job_matches
        expect(assigns(:address)).to eq('Toronto, Ontario, Canada')
      end
    end

    context 'when distance is present' do
      let(:parameters) { { search: { distance: '160000' } } }

      it 'defines @distance' do
        get :job_matches, params: parameters
        expect(assigns(:distance)).to eq('160000')
      end
    end
  end
end