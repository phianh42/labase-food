# app/models/ingredient_parsing_log.rb
class IngredientParsingLog < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :successful, -> { where('ingredients_found > 0') }
  
  # Methods
  def success_rate
    return 0 if ingredients_found.zero?
    (ingredients_added.to_f / ingredients_found * 100).round(2)
  end
  
  def summary
    "Found #{ingredients_found} ingredients, added #{ingredients_added} (#{success_rate}% success)"
  end
end