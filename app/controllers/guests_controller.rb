# app/controllers/guests_controller.rb
class GuestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_guest, only: [:show, :edit, :update, :destroy]
  
  def index
    @household_members = current_user.guests.household_members.alphabetical
    @external_guests = current_user.guests.external_guests.alphabetical
  end
  
  def show
    @meals = @guest.meals.includes(:guests, courses: { course_recipes: :recipe }).by_date
    
    if params[:start_date].present? && params[:end_date].present?
      @meals = @meals.date_range(params[:start_date], params[:end_date])
    end
    
    @recipes_summary = @guest.recipes_tried.group(:id).count
  end
  
  def new
    @guest = current_user.guests.build
  end
  
  def create
    @guest = current_user.guests.build(guest_params)
    
    if @guest.save
      redirect_to guests_path, notice: 'Guest was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @guest.update(guest_params)
      redirect_to guests_path, notice: 'Guest was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @guest.destroy
    redirect_to guests_path, notice: 'Guest was successfully removed.'
  end
  
  private
  
  def set_guest
    @guest = current_user.guests.find(params[:id])
  end
  
  def guest_params
    params.require(:guest).permit(:name, :comments, :is_household_member)
  end
end

