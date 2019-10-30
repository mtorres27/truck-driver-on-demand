# frozen_string_literal: true

require "rails_helper"

describe PublicPagesController, type: :controller do
  describe "GET public_jobs" do
    let(:jobs) { create_list :job, 10, state: "published", company: create(:company, disabled: false) }

    context "when search criteria is empty" do
      before do
        get :public_jobs
      end

      it "displays jobs" do
        expect(assigns(:jobs)).to match_array(jobs)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template("public_pages/public_jobs") }
    end

    context "when search criteria is not empty" do
      context "when keywords exists" do
        before do
          get :public_jobs, params: { search: { keywords: "Keywords" } }
        end

        it "sets @keywords" do
          expect(assigns(:keywords)).to eq("Keywords")
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template("public_pages/public_jobs") }
      end

      context "when address exists" do
        let(:geocode) { { address: "Toronto, ON, Canada", lat: 43.653226, lng: -79.3831843 } }

        before(:each) do
          allow(Rails).to receive_message_chain(:cache, :read).and_return(geocode)
          get :public_jobs, params: { search: { address: "Toronto, Ontario" } }
        end

        it "sets @address" do
          expect(assigns(:address)).to eq("Toronto, Ontario")
        end

        it "sets @geocode" do
          expect(assigns(:geocode)).to be_present
        end

        it { expect(response).to have_http_status(:ok) }
      end

      context "when country exists" do
        before(:each) do
          get :public_jobs, params: { search: { country: "Country" } }
        end
        it "sets @country" do
          expect(assigns(:country)).to eq("Country")
        end

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end
