class MealGuest < ApplicationRecord
  belongs_to :meal
  belongs_to :guest
  
  validates :guest_id, uniqueness: { scope: :meal_id }
end