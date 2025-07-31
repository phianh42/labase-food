# app/controllers/meals_controller.rb
class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal, only: [:show, :edit, :update, :destroy, :duplicate]
  
  def index
    @meals = current_user.meals.includes(:guests, courses: { course_recipes: :recipe }).by_date
    
    @meals = @meals.where(meal_type: params[:meal_type]) if params[:meal_type].present?
    
    if params[:start_date].present? && params[:end_date].present?
      @meals = @meals.date_range(params[:start_date], params[:end_date])
    end
    
    @meals = @meals.page(params[:page])
  end
  
  def show
  end
  
  def new
    @meal = current_user.meals.build(date: Date.current)
    @meal.courses.build(order_number: 1)
    @available_guests = current_user.guests.alphabetical
    @household_members = current_user.guests.household_members.alphabetical
  end
  
  def create
    @meal = current_user.meals.build(meal_params)
    
    if @meal.save
      redirect_to @meal, notice: 'Meal was successfully created.'
    else
      @available_guests = current_user.guests.alphabetical
      @household_members = current_user.guests.household_members.alphabetical
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @available_guests = current_user.guests.alphabetical
    @household_members = current_user.guests.household_members.alphabetical
    @meal.courses.build if @meal.courses.empty?
  end
  
  def update
    if @meal.update(meal_params)
      redirect_to @meal, notice: 'Meal was successfully updated.'
    else
      @available_guests = current_user.guests.alphabetical
      @household_members = current_user.guests.household_members.alphabetical
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @meal.destroy
    redirect_to meals_path, notice: 'Meal was successfully deleted.'
  end
  
  def duplicate
    @new_meal = @meal.duplicate
    @new_meal.user = current_user
    
    if @new_meal.save
      redirect_to edit_meal_path(@new_meal), notice: 'Meal duplicated successfully. Please update the date.'
    else
      redirect_to @meal, alert: 'Could not duplicate meal.'
    end
  end
  
  private
  
  def set_meal
    @meal = current_user.meals.find(params[:id])
  end
  
  def meal_params
    params.require(:meal).permit(:date, :meal_type, :notes, guest_ids: [],
      courses_attributes: [:id, :name, :order_number, :_destroy,
        course_recipes_attributes: [:id, :recipe_id, :comments, :_destroy]])
  end
end

