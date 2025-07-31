# app/models/ingredient_submission.rb
class IngredientSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  
  # Validations
  validates :ingredient_name, presence: true
  validates :status, inclusion: { in: %w[pending approved rejected] }
  
  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }
  scope :recent, -> { order(created_at: :desc) }
  
  # Callbacks
  after_update :add_to_dictionary, if: :approved?
  
  # Class method to learn from user input
  def self.learn_from_user_input(ingredient_name, user, recipe, context = nil)
    return if ingredient_name.blank?
    
    normalized_name = ingredient_name.downcase.strip
    
    unless IngredientDictionary.exists?(name: normalized_name)
      create(
        user: user,
        recipe: recipe,
        ingredient_name: normalized_name,
        context: context,
        status: 'pending'
      )
    end
  end
  
  # Instance methods
  def approve!
    update(status: 'approved')
  end
  
  def reject!
    update(status: 'rejected')
  end
  
  private
  
  def add_to_dictionary
    IngredientDictionary.find_or_create_by(name: ingredient_name) do |dict|
      dict.category = 'autres'
      dict.approved = false
      dict.submitted_by = user_id
    end
  end
end