# app/controllers/meal_planning_controller.rb
class MealPlanningController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @upcoming_meals = current_user.meals.future.includes(:guests, courses: :recipes).limit(10)
    @recent_meals = current_user.meals.past.includes(:guests, courses: :recipes).limit(5)
  end
  
  def suggestions
    @guest = current_user.guests.find(params[:guest_id]) if params[:guest_id].present?
    
    if @guest
      # Get recipes the guest hasn't tried
      tried_recipe_ids = @guest.recipes_tried.pluck(:id)
      @suggested_recipes = current_user.recipes.where.not(id: tried_recipe_ids)
                                              .public_recipes
                                              .includes(:tags)
                                              .limit(20)
      
      # Get favorite combinations from past meals
      @popular_combinations = get_popular_combinations(@guest)
    else
      # General suggestions based on least recently used recipes
      @suggested_recipes = current_user.recipes
                                      .left_joins(:course_recipes)
                                      .group('recipes.id')
                                      .order('MAX(course_recipes.created_at) ASC NULLS FIRST')
                                      .limit(20)
    end
  end
  
  private
  
  def get_popular_combinations(guest)
    # Find recipes that are often served together to this guest
    meal_ids = guest.meals.pluck(:id)
    
    Recipe.select('recipes.*, COUNT(DISTINCT meals.id) as meal_count')
          .joins(course_recipes: { course: :meal })
          .where(meals: { id: meal_ids })
          .group('recipes.id')
          .order('meal_count DESC')
          .limit(10)
  end
end

