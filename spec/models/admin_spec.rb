# == Schema Information
#
# Table name: admins
#
#  id                     :integer          not null, primary key
#  token                  :string
#  name                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :citext           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

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
