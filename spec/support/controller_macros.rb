module ControllerMacros
  def login_freelancer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:freelancer]
      freelancer = FactoryBot.create(:freelancer)
      freelancer.confirm
      sign_in freelancer
    end
  end

  def login_company
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:company]
      company = FactoryBot.create(:company)
      company.confirm
      sign_in company
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryBot.create(:admin)
      sign_in admin
    end
  end
end