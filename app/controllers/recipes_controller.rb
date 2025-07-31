# app/controllers/recipes_controller.rb
class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @recipes = Recipe.includes(:user, :tags)
    
    if params[:tag].present?
      @recipes = @recipes.tagged_with(params[:tag])
    end
    
    if params[:category].present?
      @category = Category.friendly.find(params[:category])
      @recipes = @recipes.tagged_with(@category.name)
    end
    
    if user_signed_in? && params[:my_recipes].present?
      @recipes = @recipes.by_user(current_user)
    else
      @recipes = @recipes.public_recipes unless user_signed_in? && params[:all].present?
    end
    
    @recipes = @recipes.page(params[:page])
  end

  def show
    unless @recipe.is_public? || (user_signed_in? && @recipe.user == current_user)
      redirect_to root_path, alert: "This recipe is private."
    end
  end

  def new
    @recipe = current_user.recipes.build
    # Build first step with step_number set to 1
    @recipe.recipe_steps.build(step_number: 1)
    @recipe.ingredients.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    
    if @recipe.save
      redirect_to @recipe, notice: 'Recipe was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @recipe.recipe_steps.empty?
      @recipe.recipe_steps.build(step_number: 1)
    end
    @recipe.ingredients.build if @recipe.ingredients.empty?
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: 'Recipe was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: 'Recipe was successfully destroyed.'
  end

  # AJAX endpoint for parsing ingredients
  def parse_ingredients
    @recipe = Recipe.friendly.find(params[:id])
    authorize_recipe_access!
    
    # Parse from the current form data
    if params[:steps_text].present?
      # Create temporary recipe with steps for parsing
      temp_recipe = Recipe.new
      params[:steps_text].each_with_index do |step_text, index|
        temp_recipe.recipe_steps.build(instruction: step_text, step_number: index + 1)
      end
      
      parser = IngredientParser.new(temp_recipe)
      result = parser.parse
    else
      # Parse from saved recipe
      result = @recipe.parse_ingredients_from_steps!
    end
    
    render json: {
      success: true,
      ingredients: result[:ingredients],
      confidence: result[:confidence]
    }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  # Add parsed ingredients to recipe
  def add_parsed_ingredients
    @recipe = Recipe.friendly.find(params[:id])
    authorize_recipe_access!
    
    added = @recipe.add_parsed_ingredients(params[:ingredient_ids] || [])
    
    render json: {
      success: true,
      added_count: added,
      message: "#{added} ingrédients ajoutés"
    }
  end

  private

  def set_recipe
    @recipe = Recipe.friendly.find(params[:id])
  end

  def check_owner
    redirect_to root_path, alert: "Not authorized" unless @recipe.user == current_user
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :preparation_time, :cooking_time, 
                                   :servings, :difficulty, :is_public, :image, :tag_list,
                                   recipe_steps_attributes: [:id, :step_number, :instruction, :_destroy],
                                   ingredients_attributes: [:id, :name, :quantity, :unit, :_destroy])
  end

  def authorize_recipe_access!
    unless @recipe.user == current_user
      render json: { error: 'Non autorisé' }, status: :forbidden
    end
  end
end