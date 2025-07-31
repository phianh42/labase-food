class CourseRecipe < ApplicationRecord
  belongs_to :course
  belongs_to :recipe
  
  validates :recipe_id, uniqueness: { scope: :course_id }
end