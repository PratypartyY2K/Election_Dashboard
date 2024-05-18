Rails.application.routes.draw do
  # Define the root route if you have a home page
  root 'pages#home'

  # Resources routes
  resources :users
  
  resources :candidates

  resources :constituencies do
    resources :candidates # Nested routes to handle constituency's candidates
  end

  # You can also define specific custom routes if needed, for example:
  # get 'users/:id/voting_history', to: 'users#voting_history'
  # get 'constituencies/:id/results', to: 'constituencies#results'

  # Routes for parties if needed
  resources :parties
end
