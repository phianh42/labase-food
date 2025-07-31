class Course < ApplicationRecord
  belongs_to :meal
  has_many :course_recipes, dependent: :destroy
  has_many :recipes, through: :course_recipes
  
  validates :name, presence: true
  validates :order_number, presence: true, numericality: { greater_than: 0 }
  
  accepts_nested_attributes_for :course_recipes, allow_destroy: true, reject_if: :all_blank
  
  default_scope { order(order_number: :asc) }
end