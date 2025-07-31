
# app/controllers/admin/ingredient_dictionaries_controller.rb
class Admin::IngredientDictionariesController < Admin::BaseController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy, :approve, :reject]
  
  def index
    @pending = IngredientDictionary.pending.page(params[:pending_page])
    @approved = IngredientDictionary.approved.page(params[:approved_page])
  end
  
  def new
    @ingredient = IngredientDictionary.new
  end
  
  def create
    @ingredient = IngredientDictionary.new(ingredient_params)
    @ingredient.submitted_by = current_user.id
    
    if @ingredient.save
      redirect_to admin_ingredient_dictionaries_path, notice: 'Ingrédient créé'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @ingredient.update(ingredient_params)
      redirect_to admin_ingredient_dictionaries_path, notice: 'Ingrédient mis à jour'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @ingredient.destroy
    redirect_to admin_ingredient_dictionaries_path, notice: 'Ingrédient supprimé'
  end
  
  def approve
    @ingredient.update(approved: true)
    redirect_back(fallback_location: admin_ingredient_dictionaries_path)
  end
  
  def reject
    @ingredient.update(approved: false)
    redirect_back(fallback_location: admin_ingredient_dictionaries_path)
  end

  def show
  end
  
  private
  
  def set_ingredient
    @ingredient = IngredientDictionary.find(params[:id])
  end
  
  def ingredient_params
    params.require(:ingredient_dictionary).permit(:name, :plural_form, :category, :gender, :approved, aliases: [])
  end
end

