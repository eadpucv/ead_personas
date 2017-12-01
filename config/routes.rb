Rails.application.routes.draw do
  use_doorkeeper
  # Custom
  root :to => "users#index"
  # Perfil
  get 'profile/:id' => 'users#profile'
  # Sesiones
  resources :session
  get "log_in" => "session#new", :as => "log_in"
  get "log_out" => "session#destroy", :as => "log_out"
  post "session_create" => "session#create", :as => "session_create"
  # Helpers
  get 'login' => 'session#login'
  get 'logout' => 'session#logout'
  get 'useradmin/:userid' => 'users#user_admin'
  get 'userlock/:userid' => 'users#user_lock'
  get 'userdel/:userid' => 'users#user_del'
  get 'export' => 'users#export'
  get 'message/:to' => 'users#message'
  get 'recovery' => 'users#recovery'
  get 'passwordreset/:hash' => 'users#passwordreset'
  get 'passwordreset' => 'users#passwordreset'
  post 'passwordreset' => 'users#passwordreset'
  post 'recovery_enpoint' => 'users#recovery_enpoint'
  post 'send_message' => 'users#send_message'
  get 'others/terminos' => 'users#eula'
  get 'advanced_exporter' => 'users#advanced_exporter'
  post 'advanced_exporter' => 'users#advanced_exporter'
  post 'advanced_exporter_list' => 'users#advanced_exporter_list'
  get 'fix_email' => 'users#fix_email'
  # get 'me' => 'api#me'
  resources :users
end
