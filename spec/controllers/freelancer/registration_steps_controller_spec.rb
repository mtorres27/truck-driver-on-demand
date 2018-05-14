require "rails_helper"

RSpec.describe Freelancer::RegistrationStepsController, type: :controller do
  describe "GET #show" do
    let(:freelancer) { create(:freelancer) }

    before do
      session[:step_freelancer_id] = freelancer.id
    end

    describe "step: personal" do
      it "renders personal template" do
        get :show, params: { id: :personal }
        expect(response).to render_template('freelancer/registration_steps/personal')
      end
    end
  end

  describe "PUT #update" do
    let(:freelancer) { create(:freelancer, name: nil) }

    before do
      session[:step_freelancer_id] = freelancer.id
    end

    describe "step: personal" do
      context "when the fields are filled" do
        let(:freelancer_params) { { first_name: "Test", last_name: "Testerson", city: "Chicago", state: "Illinois", country: "us" } }

        it "updates personal information" do
          put :update, params: { id: :personal, freelancer: freelancer_params }
          expect(freelancer.reload).to have_attributes( { name: "Test Testerson", city: "Chicago", state: "Illinois", country: "us" })
        end

        it "redirects to job info path" do
          put :update, params: { id: :personal, freelancer: freelancer_params }
          expect(response).to redirect_to(freelancer_registration_step_path(:job_info))
        end
      end

      context "when the fields are not filled" do
        let(:freelancer) { create(:freelancer, name: nil, last_name: nil, city: nil, country: nil) }
        let(:freelancer_params) { {} }

        it "does not update personal information" do
          put :update, params: { id: :personal, freelancer: freelancer_params }
          expect(freelancer.reload.name).to be_nil
          expect(freelancer.reload.last_name).to be_nil
          expect(freelancer.reload.city).to be_nil
          expect(freelancer.reload.country).to be_nil
        end
      end
    end

    describe "step :job_info" do
      context "when job types are not selected" do
        let(:freelancer_params) { {} }

        it "does not update the freelancer" do
          put :update, params: { id: :job_info, freelancer: freelancer_params }
          expect(freelancer.reload.job_types).to be_nil
        end

        it "includes expected errors on the freelancer" do
          put :update, params: { id: :job_info, freelancer: freelancer_params }
          expect(assigns(:freelancer).errors[:job_types]).not_to be_empty
        end
      end

      context "when job types are selected" do
        let(:freelancer_params) do
          {
            job_types: {
              system_integration: "1"
            },
            job_functions: {
              audio_technician: "1"
            }
          }
        end

        it "updates the freelancer with the correct params" do
          put :update, params: { id: :job_info, freelancer: freelancer_params }
          expect(freelancer.reload).to have_attributes(freelancer_params)
        end
      end
    end

    describe "step :profile" do
      context "when user does not fill the fields" do
        let(:freelancer_params) { {} }

        it "does not update the freelancer" do
          put :update, params: { id: :profile, freelancer: freelancer_params }
          expect(freelancer.reload.bio).to be_nil
          expect(freelancer.tagline).to be_nil
        end
      end

      context "when user fills the fields" do
        let(:freelancer_params) {
          {
            bio: "my bio",
            tagline: "my tagline",
          }
        }

        it "updates profile information" do
          put :update, params: { id: :profile, freelancer: freelancer_params }
          expect(freelancer.reload).to have_attributes(freelancer_params)
        end
      end
    end
  end
end
