class Recipe < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  acts_as_taggable_on :tags
  
  belongs_to :user
  has_many :recipe_steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  has_many :course_recipes, dependent: :destroy
  has_many :courses, through: :course_recipes
  has_many :meals, through: :courses
  
  # New associations
  has_many :ingredient_submissions, dependent: :destroy
  has_many :ingredient_parsing_logs, dependent: :destroy

  has_one_attached :image
  
  accepts_nested_attributes_for :recipe_steps, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank
  
  validates :title, presence: true
  validates :difficulty, inclusion: { in: %w[easy medium hard] }, allow_blank: true
  
  scope :public_recipes, -> { where(is_public: true) }
  scope :by_user, ->(user) { where(user: user) }

  # Scopes for parsing
  scope :with_parsed_ingredients, -> { where.not(parsed_ingredients: nil) }
  scope :needs_parsing, -> { where(parsed_ingredients: nil) }
  
  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[title description difficulty preparation_time cooking_time servings created_at updated_at is_public]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user tags ingredients recipe_steps]
  end

  def self.search_all_fields(search_term)
    return none if search_term.blank?
    
    # Use LEFT JOINs to include all recipes, even those without ingredients/steps
    ids = left_joins(:user, :ingredients, :recipe_steps)
          .where(
            "recipes.title ILIKE ? OR 
             recipes.description ILIKE ? OR
             ingredients.name ILIKE ? OR
             recipe_steps.instruction ILIKE ? OR
             users.username ILIKE ?",
            "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", 
            "%#{search_term}%", "%#{search_term}%"
          )
          .pluck(:id)
          .uniq
    
    where(id: ids)
  end
  def total_time
    (preparation_time || 0) + (cooking_time || 0)
  end

  def guests_served_to
    Guest.joins(meals: { courses: :course_recipes })
         .where(course_recipes: { recipe_id: id })
         .distinct
  end
  
  def times_served
    course_recipes.count
  end
  
  def serving_history
    CourseRecipe.where(recipe_id: id)
                .includes(course: { meal: :guests })
                .order('meals.date DESC')
  end

  # Methods for ingredient parsing
  def parse_ingredients_from_steps!
    return [] if recipe_steps.empty?
    
    result = IngredientParser.new(self).parse
    
    # Store the results
    update_columns(
      parsed_ingredients: result[:ingredients],
      ingredients_parsed_at: Time.current,
      parsing_version: IngredientParser::VERSION
    )
    
    # Log the parsing
    ingredient_parsing_logs.create!(
      user: user,
      original_text: recipe_steps.map(&:instruction).join(' '),
      results: result,
      ingredients_found: result[:ingredients].size,
      ingredients_added: 0, # Will be updated when user confirms
      confidence_score: result[:confidence]
    )
    
    result[:ingredients]
  end
  
  def has_parsed_ingredients?
    parsed_ingredients.present? && ingredients_parsed_at.present?
  end
  
  def parsing_outdated?
    return true unless has_parsed_ingredients?
    parsing_version != IngredientParser::VERSION
  end
  
  # Add detected ingredients to recipe
  def add_parsed_ingredients(ingredient_ids)
    return unless parsed_ingredients.present?
    
    added_count = 0
    parsed_ingredients.each do |parsed_ing|
      next unless ingredient_ids.include?(parsed_ing['id'].to_s)
      
      ingredients.create(
        name: parsed_ing['name'],
        quantity: parsed_ing['quantity'],
        unit: parsed_ing['unit']
      )
      added_count += 1
    end
    
    # Update the latest log
    ingredient_parsing_logs.last&.update(ingredients_added: added_count)
    
    added_count
  end
  
  private
  
end