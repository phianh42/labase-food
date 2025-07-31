# config/routes.rb
Rails.application.routes.draw do
  get "reports/by_guest"
  get "reports/by_recipe"
  get "meal_planning/index"
  get "meal_planning/suggestions"
  get "meals/index"
  get "meals/show"
  get "meals/new"
  get "meals/create"
  get "meals/edit"
  get "meals/update"
  get "meals/destroy"
  get "meals/duplicate"
  get "guests/index"
  get "guests/show"
  get "guests/new"
  get "guests/create"
  get "guests/edit"
  get "guests/update"
  get "guests/destroy"
  devise_for :users
  root 'home#index'
  
  resources :recipes do
    member do
      post :parse_ingredients
      post :add_parsed_ingredients
    end
    collection do
      post :parse_ingredients_preview
    end
  end

  post 'ingredients/track', to: 'ingredients#track'

  # Admin routes
  namespace :admin do
    resources :ingredient_dictionaries do
      member do
        patch :approve
        patch :reject
      end
    end
    
    resources :ingredient_submissions, only: [:index] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  resources :users, only: [:show, :edit, :update]
  resources :favorites, only: [:create, :destroy]
  
  # New routes for meal tracking
  resources :guests
  resources :meals do
    member do
      post :duplicate
    end
  end
  
  resources :meal_planning, only: [:index] do
    collection do
      get :suggestions
    end
  end
  
  resources :reports, only: [] do
    collection do
      get :by_guest
      get :by_recipe
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end