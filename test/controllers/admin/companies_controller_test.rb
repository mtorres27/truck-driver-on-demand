require 'test_helper'

class Admin::CompaniesControllerTest < ActionDispatch::IntegrationTest

  # TODO: Can't actually test anything yet because rails 5 removed access to the session,
  # so instead we have to actually do or fake an omniauth auth somehow.

  # def sign_in
  #   post sessions_url(section: "admin")
  # end
  #
  # setup do
  #   @company = create(:company)
  # end
  #
  # test "should get index" do
  #   get admin_companies_url
  #   assert_response :success
  # end
  #
  # test "should show company" do
  #   get admin_company_url(@company)
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get edit_admin_company_url(@company)
  #   assert_response :success
  # end
  #
  # test "should update company" do
  #   patch admin_company_url(@company), params: { company: {  } }
  #   assert_redirected_to admin_company_url(@company)
  # end
  #
  # test "should destroy company" do
  #   assert_difference("Company.count", -1) do
  #     delete admin_company_url(@company)
  #   end
  #
  #   assert_redirected_to admin_companies_url
  # end
end
