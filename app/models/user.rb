# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :recipes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_recipes, through: :favorites, source: :recipe

  has_many :meals, dependent: :destroy
  has_many :guests, dependent: :destroy
  
  has_one_attached :avatar
  
  validates :username, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[username]
  end
  
  def admin?
    # Add an admin boolean field to users table
    # rails generate migration AddAdminToUsers admin:boolean
    # Or check by email
    email.include? 'phianh'
  end

end