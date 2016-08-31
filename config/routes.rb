Rails.application.routes.draw do
  # # Auto
  # get 'home/index'
  # get 'home/acerca'
  # get 'home/terminos'
  # get 'admin/list'
  # get 'admin/mailing'

  # Custom
  root :to => "users#index"

  # Perfil
  get 'profile/:user_id' => 'users#profile'

  # Helpers
  get 'login' => 'session#login'
  get 'logout' => 'session#logout'

  resources :users

  # Legacy
  # root :to => "user#index"
  # get 'profile/:user_id' => 'user#profile'
  # get 'home_user' => 'user#home_user'
  # get 'admin/list' => 'admin#list'
  # get 'logout' => 'sessions#logout'
  # get 'api/data4wp' => 'user#data_for_wp'
  # get ':controller(/:action(/:id(.:format)))'
end
