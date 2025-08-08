# app/models/recipe_step.rb
class RecipeStep < ApplicationRecord
  belongs_to :recipe
  
  validates :instruction, presence: true
  validates :step_number, presence: true, numericality: { greater_than: 0 }
  
  default_scope { order(step_number: :asc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[instruction step_number]
  end

  
end