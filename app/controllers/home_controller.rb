# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @recent_recipes = Recipe.public_recipes.includes(:user, :tags).limit(10)
    @categories = Category.all
  end
end