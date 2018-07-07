require "rails_helper"

RSpec.describe Freelancer::RegistrationStepsController, type: :controller do
  describe "GET #show" do
    describe "step: personal" do
      let(:freelancer) { create(:freelancer) }

      context "when current_freelancer exists" do
        before { sign_in freelancer }

        it "renders personal template" do
          get :show, params: { id: :personal }
          expect(response).to render_template('freelancer/registration_steps/personal')
        end
      end

      context "when current_freelancer does not exist" do
        it "redirects to freelancer login page" do
          get :show, params: { id: :personal }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe "PUT #update" do
    let(:freelancer) { create(:freelancer) }

    before do
      sign_in freelancer
    end

    describe "step: personal" do
      context "when the fields are filled" do
        let(:freelancer_params) { { city: "Chicago", state: "Illinois", country: "us" } }

        it "updates personal information" do
          put :update, params: { id: :personal, freelancer_profile: freelancer_params }
          expect(freelancer.freelancer_profile.reload).to have_attributes( { city: "Chicago", state: "Illinois", country: "us" })
        end

        it "redirects to job info path" do
          put :update, params: { id: :personal, freelancer_profile: freelancer_params }
          expect(response).to redirect_to(freelancer_registration_step_path(:job_info))
        end
      end

      context "when the fields are not filled" do
        let(:freelancer) { create(:freelancer, freelancer_profile: create(:freelancer_profile, city: nil, country: nil)) }
        let(:freelancer_params) { {} }

        it "does not update personal information" do
          put :update, params: { id: :personal, freelancer_profile: freelancer_params }
          expect(freelancer.freelancer_profile.reload.city).to be_nil
          expect(freelancer.freelancer_profile.reload.country).to be_nil
        end
      end
    end

    describe "step :job_info" do
      before do
        freelancer.freelancer_profile.update(registration_step: "job_info")
      end

      context "when job types are not selected" do
        let(:freelancer_params) { {} }

        it "does not update the freelancer" do
          put :update, params: { id: :job_info, freelancer_profile: freelancer_params }
          expect(freelancer.freelancer_profile.reload.job_types).to be_nil
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
          put :update, params: { id: :job_info, freelancer_profile: freelancer_params }
          expect(freelancer.freelancer_profile.reload).to have_attributes(freelancer_params)
        end
      end
    end

    describe "step :profile" do
      before do
        freelancer.freelancer_profile.update_attribute(:registration_step, "profile")
      end

      context "when user does not fill the fields" do
        let(:freelancer_params) { { bio: nil, tagline: nil } }

        it "does not update the freelancer" do
          put :update, params: { id: :profile, freelancer_profile: freelancer_params }

          freelancer.freelancer_profile.reload

          expect(freelancer.freelancer_profile.bio).not_to be_empty
          expect(freelancer.freelancer_profile.tagline).not_to be_empty
        end
      end

      context "when user fills the fields" do
        let(:freelancer_params) {
          {
            bio: "my bio",
            tagline: "my tagline",
            avatar: fixture_file_upload(Rails.root.join("spec", "fixtures", "image.png"), "image/png")
          }
        }

        it "updates profile information" do
          put :update, params: { id: :profile, freelancer_profile: freelancer_params }
          expect(freelancer.freelancer_profile.reload.bio).to eq("my bio")
          expect(freelancer.freelancer_profile.tagline).to eq("my tagline")
          expect(freelancer.freelancer_profile.avatar).not_to be_nil
        end
      end
    end
  end
end
