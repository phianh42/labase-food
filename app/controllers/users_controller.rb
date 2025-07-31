# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user
  before_action :check_user, only: [:edit, :update]

  def show
    @recipes = @user.recipes
    @recipes = @recipes.public_recipes unless user_signed_in? && @user == current_user
    @favorite_recipes = @user.favorite_recipes.public_recipes if user_signed_in? && @user == current_user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def check_user
    redirect_to root_path, alert: "Not authorized" unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:username, :bio, :avatar)
  end
end