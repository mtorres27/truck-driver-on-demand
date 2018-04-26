require 'rails_helper'

describe Company, type: :model do
  describe "hooks" do
    describe "after create" do
      describe "add_to_hubspot" do
        it "creates or update a hubspot contact" do
          expect(Hubspot::Contact).to receive(:createOrUpdate).with(
            "test@test.com",
            company: "Acme",
            firstname: "John",
            lastname: "Doe",
            lifecyclestage: "customer",
            im_am: "AV Company",
          )
          create(:company, email: "test@test.com", contact_name: "John Doe", name: "Acme")
        end
      end
    end
  end
end
