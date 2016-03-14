Rails.application.routes.draw do
  # # Auto
  # get 'home/index'
  # get 'home/acerca'
  # get 'home/terminos'
  # get 'admin/list'
  # get 'admin/mailing'

  # Legacy
  root :to => "home#index"
  get 'home_user' => 'user#home_user'
  get 'admin/list' => 'admin#list'
  get 'logout' => 'sessions#logout'
  get 'api/data4wp' => 'user#data_for_wp'
  get ':controller(/:action(/:id(.:format)))'
end
