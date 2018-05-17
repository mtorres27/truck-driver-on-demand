require "rails_helper"

RSpec.describe Company::RegistrationStepsController, type: :controller do
  describe "GET #show" do
    let(:company) { create(:company) }

    before do
     sign_in company
    end

    describe "step: personal" do
      it "renders personal template" do
        get :show, params: { id: :personal }
        expect(response).to render_template('company/registration_steps/personal')
      end
    end
  end

  describe "PUT #update" do
    let(:company) { create(:company) }

    before do
      sign_in company
    end

    describe "step: personal" do
      context "when the fields are filled" do
        let(:company_params) { { first_name: "Test", last_name: "Testerson", name: "AV Junction", city: "Chicago", state: "Illinois", country: "us" } }

        it "updates personal information" do
          put :update, params: { id: :personal, company: company_params }
          expect(company.reload).to have_attributes( { contact_name: "Test Testerson", name: "AV Junction", city: "Chicago", state: "Illinois", country: "us" })
        end

        it "redirects to job info path" do
          put :update, params: { id: :personal, company: company_params }
          expect(response).to redirect_to(company_registration_step_path(:job_info))
        end
      end

      context "when the fields are not filled" do
        let(:company) { create(:company, name: nil, last_name: nil, city: nil, country: nil) }
        let(:company_params) { {} }

        it "does not update personal information" do
          put :update, params: { id: :personal, company: company_params }
          expect(company.name).to be_nil
          expect(company.last_name).to be_nil
          expect(company.city).to be_nil
          expect(company.country).to be_nil
        end
      end
    end

    describe "step :job_info" do
      before do
        company.update(registration_step: "job_info")
      end

      context "when job types are not selected" do
        let(:company_params) { {} }

        it "does not update the company" do
          put :update, params: { id: :job_info, company: company_params }
          expect(company.reload.job_types).to be_nil
        end

        it "includes expected errors on the company" do
          put :update, params: { id: :job_info, company: company_params }
          expect(assigns(:company).errors[:job_types]).not_to be_empty
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
          expect(company.reload).to have_attributes(company_params)
        end
      end
    end

    describe "step :profile" do
      before do
        company.update_attribute(:registration_step, "profile")
      end

      context "when user does not fill the fields" do
        let(:company_params) { {} }

        it "does not update the company" do
          put :update, params: { id: :profile, company: company_params }
          expect(company.reload.description).to be_nil
          expect(company.established_in).to be_nil
          expect(company.number_of_employees).to be_nil
          expect(company.number_of_offices).to eq(0)
          expect(company.website).to be_nil
          expect(company.area).to be_nil
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
          expect(company.reload).to have_attributes(company_params)
        end
      end
    end
  end
end
