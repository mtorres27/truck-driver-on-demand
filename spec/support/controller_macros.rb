# frozen_string_literal: true

module ControllerMacros

  def login_driver
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:driver]
      driver = FactoryBot.create(:driver)
      driver.confirm
      sign_in driver
    end
  end

  def login_company
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:company]
      company = FactoryBot.create(:company)
      company_user = FactoryBot.create(:company_user, company: company)
      company_user.confirm
      sign_in company_user
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
