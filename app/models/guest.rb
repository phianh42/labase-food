class Guest < ApplicationRecord
  belongs_to :user
  has_many :meal_guests, dependent: :destroy
  has_many :meals, through: :meal_guests
  
  validates :name, presence: true, uniqueness: { scope: :user_id }
  
  scope :household_members, -> { where(is_household_member: true) }
  scope :external_guests, -> { where(is_household_member: false) }
  scope :alphabetical, -> { order(name: :asc) }
  
  def meals_attended_count
    meals.count
  end
  
  def recipes_tried
    Recipe.joins(course_recipes: { course: :meal })
          .where(meals: { id: meals.pluck(:id) })
          .distinct
  end
  
  def recipes_by_date
    CourseRecipe.joins(course: :meal)
                .where(meals: { id: meals.pluck(:id) })
                .includes(:recipe, course: :meal)
                .order('meals.date DESC')
  end
end