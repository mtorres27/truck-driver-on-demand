# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  authorable_type :string           not null
#  authorable_id   :bigint           not null
#  receivable_type :string           not null
#  receivable_id   :bigint           not null
#  body            :text
#  title           :text
#  read_at         :datetime
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "rails_helper"

describe Notification, type: :model do
  describe "validations" do
    let(:company) { create(:company) }
    let(:driver) { create(:driver) }
    subject { create(:notification, authorable: company, receivable: driver) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:authorable) }
    it { is_expected.to validate_presence_of(:receivable) }
  end
end
