require "test_helper"

class MealPlanningControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meal_planning_index_url
    assert_response :success
  end

  test "should get suggestions" do
    get meal_planning_suggestions_url
    assert_response :success
  end
end
