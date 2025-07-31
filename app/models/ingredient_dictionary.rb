# app/models/ingredient_dictionary.rb
class IngredientDictionary < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
  
  # Scopes
  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }
  scope :by_category, ->(category) { where(category: category) }
  
  # Categories
  CATEGORIES = %w[
    légumes fruits viandes poissons épices 
    produits_laitiers céréales condiments 
    huiles_graisses herbes_aromatiques autres
  ]
  
  # Gender for French grammar
  GENDERS = %w[m f]
  
  validates :category, inclusion: { in: CATEGORIES }
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  
  # Serialize aliases as JSON array - Rails 8 syntax
  serialize :aliases, coder: JSON
  
  # Methods
  def all_forms
    forms = [name]
    forms << plural_form if plural_form.present?
    forms += aliases if aliases.present?
    forms.compact.uniq
  end
  
  def display_name
    approved? ? name : "#{name} (en attente)"
  end
  
  # Class method to search
  def self.search_ingredient(term)
    term = term.downcase.strip
    
    # Search in name, plural_form, and aliases
    where("LOWER(name) = ? OR LOWER(plural_form) = ?", term, term)
      .or(where("aliases LIKE ?", "%#{term}%"))
      .approved
      .first
  end
end