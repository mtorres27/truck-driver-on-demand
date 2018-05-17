require 'rails_helper'

describe Company, type: :model do
  describe "hooks" do
    describe "after create" do
      describe "confirm_user" do
        let(:admin) { create(:admin, user: build(:user)) }

        it "confirms the user" do
          expect(admin.user.confirmed_at).to be_present
        end
      end
    end
  end
end