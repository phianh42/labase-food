# app/controllers/favorites_controller.rb
class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @recipe = Recipe.friendly.find(params[:recipe_id])
    @favorite = current_user.favorites.build(recipe: @recipe)
    
    if @favorite.save
      redirect_back(fallback_location: @recipe, notice: 'Recipe added to favorites.')
    else
      redirect_back(fallback_location: @recipe, alert: 'Could not add to favorites.')
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @recipe = @favorite.recipe
    @favorite.destroy
    redirect_back(fallback_location: @recipe, notice: 'Recipe removed from favorites.')
  end
end