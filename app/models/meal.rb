class Meal < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  has_many :meal_guests, dependent: :destroy
  has_many :guests, through: :meal_guests
  
  accepts_nested_attributes_for :courses, allow_destroy: true, reject_if: :all_blank
  
  validates :date, presence: true
  validates :meal_type, presence: true, inclusion: { in: %w[breakfast lunch dinner snack] }
  
  scope :future, -> { where('date >= ?', Date.current) }
  scope :past, -> { where('date < ?', Date.current) }
  scope :by_date, -> { order(date: :desc) }
  scope :date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  
  def display_name
    "#{meal_type.capitalize} - #{date.strftime('%B %d, %Y')}"
  end
  
  def duplicate
    new_meal = self.dup
    new_meal.date = Date.current
    
    courses.each do |course|
      new_course = course.dup
      new_meal.courses << new_course
      
      course.course_recipes.each do |cr|
        new_course.course_recipes << cr.dup
      end
    end
    
    new_meal.guest_ids = guest_ids
    new_meal
  end
  
  def all_recipes
    Recipe.joins(course_recipes: :course)
          .where(courses: { meal_id: id })
          .distinct
  end
end