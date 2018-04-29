require "rails_helper"

RSpec.describe Freelancer::RegistrationStepsController, type: :controller do
  describe "PUT #update" do
    let(:freelancer) { create(:freelancer) }

    before do
      sign_in freelancer
    end

    describe "step: personal" do
      let(:freelancer_params) do
        {
          name: "Test",
          lastname: "Testerson",
          city: "Chicago",
          company_name: "AvJunction",
          country: "us",
        }
      end

      it "updates personal information" do
        put :update, params: { id: :personal, freelancer: freelancer_params }
        freelancer.reload
        expect(freelancer).to have_attributes(freelancer_params)
      end
    end

    describe "step :job_info" do
      context "when job types are not selected" do
        let(:freelancer_params) do
          {}
        end

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
          freelancer.reload
          expect(freelancer).to have_attributes(freelancer_params)
        end
      end
    end

    describe "step :profile" do
      context "when user does not fill the fields" do
        let(:freelancer_params) do
          {}
        end

        it "does not update the freelancer" do
          put :update, params: { id: :profile, freelancer: freelancer_params }
          expect(freelancer.reload.bio).to be_nil
          expect(freelancer.reload.tagline).to be_nil
        end
      end

      context "when user fill the fields" do
        let(:freelancer_params) do
          {
            bio: "my bio",
            tagline: "my tagline",
          }
        end

        it "updates profile information" do
          put :update, params: { id: :profile, freelancer: freelancer_params }
          freelancer.reload
          expect(freelancer).to have_attributes(freelancer_params)
        end
      end
    end
  end
end
