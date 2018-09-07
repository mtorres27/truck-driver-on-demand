# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  authorable_type :string
#  authorable_id   :integer          not null
#  receivable_type :string
#  receivable_id   :integer          not null
#  body            :text
#  title           :text
#  read_at         :datetime
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notifications_on_authorable_type_and_authorable_id  (authorable_type,authorable_id)
#  index_notifications_on_receivable_type_and_receivable_id  (receivable_type,receivable_id)
#

require 'rails_helper'

describe Notification, type: :model do
  describe "validations" do
    let(:company) { create(:company) }
    let(:freelancer) { create(:freelancer) }
    subject { create(:notification, authorable: company, receivable: freelancer) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:authorable) }
    it { is_expected.to validate_presence_of(:receivable) }
  end
end
