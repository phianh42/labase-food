# app/controllers/reports_controller.rb
class ReportsController < ApplicationController
  before_action :authenticate_user!
  
  def by_guest
    @guest = current_user.guests.find(params[:guest_id])
    @recipes_history = @guest.recipes_by_date
                            .includes(:recipe, course: { meal: :guests })
                            .page(params[:page])
    
    @recipe_counts = @guest.recipes_tried
                          .group('recipes.id')
                          .count
                          .sort_by { |_, count| -count }
  end
  
  def by_recipe
    @recipe = Recipe.friendly.find(params[:recipe_id])
    
    unless @recipe.user == current_user || @recipe.is_public?
      redirect_to root_path, alert: "Not authorized"
      return
    end
    
    @serving_history = @recipe.serving_history
                             .joins(course: { meal: :user })
                             .where(meals: { user_id: current_user.id })
                             .includes(course: { meal: :guests })
                             .page(params[:page])
    
    @guest_counts = Guest.joins(meals: { courses: :course_recipes })
                        .where(course_recipes: { recipe_id: @recipe.id })
                        .where(guests: { user_id: current_user.id })
                        .group('guests.id')
                        .count
                        .sort_by { |_, count| -count }
  end
end