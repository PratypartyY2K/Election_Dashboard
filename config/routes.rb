Rails.application.routes.draw do
  # Define the root route if you have a home page
  root 'pages#home'
  get 'users/gender_options', to: 'users#gender_options'
  get 'candidates/gender_options', to: 'candidates#gender_options'
  get 'constituencies/type_options', to: 'constituencies#type_options'
  # Resources routes
  resources :users
  resources :candidates
  resources :constituencies do
    resources :users
  end
  resources :parties do
    resources :candidates
  end
  resources :constituencies do
    resources :candidates
  end
end
