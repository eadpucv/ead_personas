Persons::Application.routes.draw do
  	root :to => "others#index"
	match 'home_user' => 'user#home_user'

	match 'admin/list' => 'admin#list'
	match 'logout' => 'sessions#logout'

  	match ':controller(/:action(/:id(.:format)))'
end

