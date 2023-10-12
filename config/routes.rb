Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'register', to: 'registrations#create'
  post 'reconfirm', to: 'registrations#user_reconfirm'

  post 'login', to: 'sessions#login'

  get 'users/confirm_email/:token', to: 'users#confirm_email'
  get 'users/info/', to: 'users#user_info'
  patch 'users/update_password', to: 'users#update_password'
  patch 'users/update_info', to: 'users#update_info'

  get 'artists', to: 'sellers#index'
  get 'artists/:username', to: 'sellers#show'
  delete 'artists/avatar_url/delete/:id', to: 'sellers#avatar_destroy'
  patch 'artists/avatar_url/update/:id', to: 'sellers#avatar_update'
  delete 'artists/cover_url/delete/:id', to: 'sellers#cover_destroy'
  patch 'artists/cover_url/update/:id', to: 'sellers#cover_update'
  delete 'artists/works1_url/delete/:id', to: 'sellers#works1_destroy'
  patch 'artists/works1_url/update/:id', to: 'sellers#works1_update'
  delete 'artists/works2_url/delete/:id', to: 'sellers#works2_destroy'
  patch 'artists/works2_url/update/:id', to: 'sellers#works2_update'
  delete 'artists/works3_url/delete/:id', to: 'sellers#works3_destroy'
  patch 'artists/works3_url/update/:id', to: 'sellers#works3_update'
  delete 'artists/works4_url/delete/:id', to: 'sellers#works4_destroy'
  patch 'artists/works4_url/update/:id', to: 'sellers#works4_update'
  patch 'artists/update_bio/:id', to: 'sellers#update_bio'

  post 'commission_types/create', to: 'commission_types#create'
  get 'commission_types/my_commissions', to: 'commission_types#my_commissions'
  patch 'commission_types/my_commissions/:id', to: 'commission_types#update_commissions'
  delete 'commission_types/my_commissions/:id', to: 'commission_types#delete_commissions'
end
