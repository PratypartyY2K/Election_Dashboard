Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Define the root route if you have a home page
  root 'pages#home'

  get 'users/gender_options', to: 'users#gender_options'
  get 'candidates/gender_options', to: 'candidates#gender_options'
  get 'constituencies/type_options', to: 'constituencies#type_options'
  # Resources routes
  resources :users
  resources :candidates
  resources :constituencies
  resources :parties
end
