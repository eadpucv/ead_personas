Rails.application.routes.draw do
  # # Auto
  # get 'home/index'
  # get 'home/acerca'
  # get 'home/terminos'
  # get 'admin/list'
  # get 'admin/mailing'

  # Custom
  root :to => "user#index"
  # Perfil
  get 'profile/:user_id' => 'user#profile'
  # Gestion de cuentas
  scope '/user' do
    get '/new' => 'user#new'
    post '/' => 'user#create'
    get '/:user_id' => 'user#edit'
    patch '/' => 'user#update'
  end
  # Helpers
  get 'login' => 'session#login'
  get 'logout' => 'session#logout'  

  # Legacy
  # root :to => "user#index"
  # get 'profile/:user_id' => 'user#profile'
  # get 'home_user' => 'user#home_user'
  # get 'admin/list' => 'admin#list'
  # get 'logout' => 'sessions#logout'
  # get 'api/data4wp' => 'user#data_for_wp'
  # get ':controller(/:action(/:id(.:format)))'
end
