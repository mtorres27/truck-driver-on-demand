require 'rails_helper'

describe Freelancer::FriendInvitesController, type: :controller  do
  describe 'GET show' do
    login_freelancer

    context 'when no invites or credit' do
      before(:each) do
        get :show
      end

      it 'sets the right variables' do
        expect(assigns(:avj_credit)).to eq(0)
        expect(assigns(:friend_invites).count).to eq(0)
      end
    end

    context 'when invites and no credit' do
      before(:each) do
        create(:friend_invite, freelancer: subject.current_user)
        get :show
      end

      it 'sets the right variables' do
        expect(assigns(:avj_credit)).to eq(0)
        expect(assigns(:friend_invites).count).to eq(1)
      end
    end

    context 'when invites and credit' do
      before(:each) do
        subject.current_user.freelancer_profile.update_attribute(:avj_credit, 50)
        create(:friend_invite, freelancer: subject.current_user)
        get :show
      end

      it 'sets the right variables' do
        expect(assigns(:avj_credit)).to eq(50)
        expect(assigns(:friend_invites).count).to eq(1)
      end
    end
  end

  describe 'PATCH update' do
    login_freelancer

    context 'when no errors' do
      before(:each) do
        @invites_count = FriendInvite.count
        patch :update, params: { 'freelancer'=> {'friend_invites_attributes' => { '1' => { 'name' => 'Example', 'email' => 'example@example.com' } } } }
      end

      it 'creates friend invites' do
        expect(FriendInvite.count).to eq(@invites_count + 1)
      end

      it 'redirects to friend invites' do
        expect(response).to redirect_to(freelancer_friend_invites_path)
      end
    end

    context 'when errors' do
      before(:each) do
        @invites_count = FriendInvite.count
        patch :update, params: { 'freelancer'=> {'friend_invites_attributes' => { '1' => { 'name' => 'Example', 'email' => nil } } } }
      end

      it 'renders show' do
        expect(response).to render_template(:show)
      end

      it 'displays error message' do
        expect(flash[:error]).to be_present
      end

      it "doesn't create any invites" do
        expect(FriendInvite.count).to eq(@invites_count)
      end
    end
  end
end
