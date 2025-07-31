require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get by_guest" do
    get reports_by_guest_url
    assert_response :success
  end

  test "should get by_recipe" do
    get reports_by_recipe_url
    assert_response :success
  end
end
