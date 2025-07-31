class Ingredient < ApplicationRecord
  belongs_to :recipe
  
  validates :name, presence: true
  
  METRIC_UNITS = %w[g kg ml cl dl l]
  CUSTOM_UNITS = %w[pinch dash bunch piece clove can tablespoon teaspoon cup]
  ALL_UNITS = METRIC_UNITS + CUSTOM_UNITS
  
  validates :unit, inclusion: { in: ALL_UNITS }, allow_blank: true
end