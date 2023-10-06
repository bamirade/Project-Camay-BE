Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'register', to: 'registrations#create'
  post 'reconfirm', to: 'registrations#user_reconfirm'

  post 'login', to: 'sessions#login'

  get 'users/confirm_email/:token', to: 'users#confirm_email'
  get 'users/info/', to: 'users#user_info'

  get 'artists', to: 'sellers#index'
  get 'artists/:username', to: 'sellers#show'
end
