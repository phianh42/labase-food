# app/models/category.rb
class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, presence: true, uniqueness: true
end