# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  type                   :string
#  messages_count         :integer          default(0), not null
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
