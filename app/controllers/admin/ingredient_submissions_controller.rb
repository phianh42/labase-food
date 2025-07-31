# app/controllers/admin/ingredient_submissions_controller.rb
class Admin::IngredientSubmissionsController < Admin::BaseController
  before_action :set_submission, only: [:approve, :reject]
  
  def index
    @submissions = IngredientSubmission.includes(:user, :recipe)
                                     .pending
                                     .recent
                                     .page(params[:page])
  end
  
  def approve
    @submission.approve!
    redirect_back(fallback_location: admin_ingredient_submissions_path, 
                  notice: "Ingrédient '#{@submission.ingredient_name}' approuvé et ajouté au dictionnaire")
  end
  
  def reject
    @submission.reject!
    redirect_back(fallback_location: admin_ingredient_submissions_path,
                  notice: "Ingrédient '#{@submission.ingredient_name}' rejeté")
  end
  
  private
  
  def set_submission
    @submission = IngredientSubmission.find(params[:id])
  end
end