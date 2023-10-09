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
  delete 'artists/avatar_url/delete/:id', to: 'sellers#avatar_destroy'
  patch 'artists/avatar_url/update/:id', to: 'sellers#avatar_update'
  delete 'artists/cover_url/delete/:id', to: 'sellers#cover_destroy'
  patch 'artists/cover_url/update/:id', to: 'sellers#cover_update'
end
