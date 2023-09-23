Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'register', to: 'registrations#create'
  post 'login', to: 'sessions#login'
  get 'users/confirm_email/:token', to: 'users#confirm_email'
end
