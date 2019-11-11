# frozen_string_literal: true

require "rails_helper"

describe Driver::JobsController, type: :controller do
  describe "GET index" do
    login_driver

    context "when search criteria is empty" do
      it "displays an error message" do
        get :index
        expect(flash[:error]).to be_present
      end

      it "redirects to driver_root_path" do
        get :index
        expect(response).to redirect_to(driver_root_path)
      end
    end

    context "when search criteria is not empty" do
      context "when keywords exists" do
        it "sets @keywords" do
          get :index, params: { search: { keywords: "Keywords" } }
          expect(assigns(:keywords)).to eq("Keywords")
        end
      end

      context "when address exists" do
        let(:geocode) { { address: "Toronto, ON, Canada", lat: 43.653226, lng: -79.3831843 } }

        before(:each) do
          allow(Rails).to receive_message_chain(:cache, :read).and_return(geocode)
          get :index, params: { search: { address: "Toronto, Ontario" } }
        end

        it "sets @address" do
          expect(assigns(:address)).to eq("Toronto, Ontario")
        end

        it "sets @geocode" do
          expect(assigns(:geocode)).to be_present
        end
      end

      context "when country exists" do
        before(:each) do
          get :index, params: { search: { country: "Country" } }
        end
        it "sets @country" do
          expect(assigns(:country)).to eq("Country")
        end
      end
    end
  end
end
