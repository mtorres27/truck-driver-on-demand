require "rails_helper"

RSpec.describe Company::RegistrationStepsController, type: :controller do
  describe "GET #show" do
    describe "step: personal" do
      let(:company_user) { create(:company_user) }

      context "when current_company exists" do
        before { sign_in company_user }

        it "renders personal template" do
          get :show, params: { id: :personal }
          expect(response).to render_template('company/registration_steps/personal')
        end
      end

      context "when current_company does not exist" do
        it "renders personal template" do
          get :show, params: { id: :personal }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "PUT #update" do
    let(:company) { create(:company) }
    let!(:company_user) { create(:company_user, company: company, role: :owner) }

    before do
      sign_in company_user
    end

    describe "step: personal" do
      context "when the fields are filled" do
        let(:company_params) { { name: "AV Junction", city: "Chicago", state: "Illinois", country: "us" } }

        it "updates personal information" do
          put :update, params: { id: :personal, company: company_params }
          expect(company_user.company.reload).to have_attributes( { name: "AV Junction", city: "Chicago", state: "Illinois", country: "us" })
        end

        it "redirects to job info path" do
          put :update, params: { id: :personal, company: company_params }
          expect(response).to redirect_to(company_registration_step_path(:job_info))
        end
      end

      context "when the fields are not filled" do
        let(:company_user) { create(:company_user, company: create(:company, name: nil, city: nil, country: nil)) }
        let(:company_params) { {} }

        it "does not update personal information" do
          put :update, params: { id: :personal, company: company_params }
          expect(company_user.company.name).to be_nil
          expect(company_user.company.city).to be_nil
          expect(company_user.company.country).to be_nil
        end
      end
    end

    describe "step :job_info" do
      before do
        company_user.company.update(registration_step: "job_info")
      end

      context "when job types are not selected" do
        let(:company_params) { {} }

        it "does not update the company" do
          put :update, params: { id: :job_info, company: company_params }
          expect(company_user.company.reload.job_types).to be_nil
        end
      end

      context "when job types are selected" do
        let(:company_params) do
          {
            job_types: {
              system_integration: "1"
            },
            job_markets: {
              broadcast: "1"
            }
          }
        end

        it "updates the company with the correct params" do
          put :update, params: { id: :job_info, company: company_params }
          expect(company_user.company.reload).to have_attributes(company_params)
        end
      end
    end

    describe "step :profile" do
      before do
        company_user.company.update_attribute(:registration_step, "profile")
      end

      context "when user does not fill the fields" do
        let(:company_params) { { description: nil, established_in: nil, number_of_employees: nil, number_of_offices: nil, website: nil, area: nil} }

        it "does not update the company" do
          put :update, params: { id: :profile, company: company_params }
          expect(company_user.company.reload.description).not_to be_empty
          expect(company_user.company.established_in).not_to be_nil
          expect(company_user.company.number_of_employees).not_to be_empty
          expect(company_user.company.number_of_offices).not_to be_nil
          expect(company_user.company.website).not_to be_empty
          expect(company_user.company.area).not_to be_empty
        end
      end

      context "when user fills the fields" do
        let(:company_params) {
          {
            description: "my description",
            established_in: 2018,
            number_of_employees: "one_to_ten",
            number_of_offices: 1,
            website: "www.avjunction.com",
            area: "USA"
          }
        }

        it "updates profile information" do
          put :update, params: { id: :profile, company: company_params }
          expect(company_user.company.reload).to have_attributes(company_params)
        end
      end
    end
  end
end
