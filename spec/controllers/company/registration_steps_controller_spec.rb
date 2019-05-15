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
    let(:company_user) { company.owner }

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
  end
end
