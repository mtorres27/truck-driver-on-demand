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
          get :index, params: { search: { address: 'Address' } }
        end
        before(:each) do
          allow(Rails).to receive(:cache).and_return(double('Readable', read: true))
        end

        it 'sets @address' do
          expect(assigns(:address)).to eq('Address')
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
end