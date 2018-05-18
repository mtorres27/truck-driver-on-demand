module ControllerMacros
  def login_freelancer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:freelancer]
      freelancer = FactoryBot.create(:freelancer)
      freelancer.user.confirm
      sign_in freelancer.user
    end
  end

  def login_company
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:company]
      company = FactoryBot.create(:company)
      company.user.confirm
      sign_in company.user
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryBot.create(:admin)
      sign_in admin.user
    end
  end
end