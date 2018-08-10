require 'rails_helper'

RSpec.describe Company::CompanyUsersController, type: :controller do
  login_company
  let(:company) { subject.current_user.company }
  let(:owner) { create(:company_user, company: company, role: :owner) }
  let(:manager) { create(:company_user, company: company, role: :manager) }

  describe 'GET company users' do
    it 'return the users' do
      get :index
      expect(assigns(:users)).to eq(company.company_users)
    end
  end

  describe 'GET company user X' do
    it 'returns the correct user' do
      get :show, params: { id: owner.id }
      expect(assigns(:company_user)).to eq(owner)
    end
  end

  describe 'GET enable/disable company user' do
    it 'disables user' do
      get :enable, params: { company_user_id: owner.id }
      expect(assigns(:company_user).enabled).to be_truthy
    end

    it 'enables user' do
      get :disable, params: { company_user_id: owner.id }
      expect(assigns(:company_user).enabled).to be_falsey
    end
  end

  describe 'POST create user' do
    let(:new_user) { attributes_for(:company_user) }

    it 'creates a new user' do
      expect {
        post :create, params: { company_user: new_user }
      }.to change{CompanyUser.count}.by(1)
    end
  end

  describe 'PUT update user' do
    let(:params) {
      {
        first_name: 'new name',
        last_name: 'new last name',
      }
    }

    it 'updates the user' do
      put :update, params: { id: manager.id, company_user: params }
      expect(manager.reload).to have_attributes(params)
    end
  end

  describe 'DELETE company user' do
    it 'deletes the user' do
      delete :destroy, params: { id: manager.id }
      expect(response).to redirect_to company_company_users_path
    end
  end
end
