require 'rails_helper'

describe Job, type: :model do
  describe "city_state_country" do
    let(:company) { create :company}
    context "when state is missing" do
      let(:job) { create :job, state_province: nil, city: 'Toronto', country: 'ca', company: company }

      it "returns location without state" do
        expect(job.city_state_country).to eq("Toronto, CA")
      end
    end
    context "when all is present" do
      let(:job) { create :job, state_province: 'Ontario', city: 'Toronto', country: 'ca', company: company }

      it "returns location with state" do
        expect(job.city_state_country).to eq("Toronto, Ontario, CA")
      end
    end
  end
end