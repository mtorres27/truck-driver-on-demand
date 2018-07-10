require "rails_helper"

RSpec.describe Company::JobStepsController, type: :controller do
  let(:company) { create(:company) }
  let(:company_user) { company.company_user }

  describe "GET #show" do
    describe "step: job_details" do
      before { sign_in company_user }

      it "renders job_details template" do
        get :show, params: { id: :job_details }
        expect(response).to render_template('company/job_steps/job_details')
      end
    end

    describe "step: candidate_details" do
      let!(:job) { create(:job, company: company, project: create(:project, company: company), creation_step: "candidate_details") }

      before { sign_in company_user }

      it "renders candidate_details template" do
        get :show, params: { id: :candidate_details }
        expect(response).to render_template('company/job_steps/candidate_details')
      end
    end

    describe "step: wicked_finish" do
      context "when creation_step is wicked_finish" do
        let!(:job) { create(:job, company: company, project: create(:project, company: company), creation_step: "wicked_finish") }

        before { sign_in company_user }

        it "redirects to job" do
          get :show, params: { id: :wicked_finish }
          expect(response).to redirect_to(company_job_path(job))
        end
      end

      context "when creation_step is not wicked_finish" do
        let!(:job) { create(:job, company: company, project: create(:project, company: company), creation_step: "candidate_details") }

        before do
          sign_in company_user
          get :show, params: { id: :wicked_finish }
        end

        it "sets step to wicked finish" do
          job.reload
          expect(job.creation_step).to eq("wicked_finish")
        end

        it "sets a flash message for publishing the job" do
          expect(flash[:notice]).to be_present
        end

        it "redirects to job" do
          expect(response).to redirect_to(company_job_path(job))
        end
      end
    end
  end

  describe "PUT #update" do
    let(:company) { create(:company) }
    let(:company_user) { company.company_user }

    before do
      sign_in company_user
    end

    describe "step: job_details" do
      context "when the fields are filled" do
        let(:project) { create(:project, company: company) }
        let(:job_params) do
          {
            project_id: project.id,
            title: "Title",
            starts_on: Date.today,
            duration: 10,
            summary: "Summary",
            scope_of_work: "Scope",
            country: "es",
            address: "Madrid",
            budget: 5000,
            currency: "EUR"
          }
        end

        before do
          put :update, params: { id: :job_details, job: job_params }
        end

        it "creates a job with given attributes" do
          expect(company.jobs.last).to have_attributes(job_params)
        end

        it "redirects to next step path" do
          expect(response).to redirect_to(company_job_step_path(:candidate_details))
        end
      end

      context "when the fields are not filled" do
        let(:job_params) { { } }

        it "does not create a job" do
          put :update, params: { id: :job_details, job: job_params }
          expect(company.jobs.count).to eq(0)
        end
      end
    end

    describe "step :candidate_details" do
      let!(:job) { create(:job, company: company, project: create(:project, company: company), creation_step: "candidate_details") }
      let(:job_params) { job.attributes }

      it "publishes the job" do
        put :update, params: { id: :candidate_details, company: job_params }
        job.reload
        expect(job.state).to eq("published")
      end
    end
  end
end
