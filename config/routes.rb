Persons::Application.routes.draw do
  	root :to => "others#index"
	match 'home_user' => 'user#home_user'

	match 'admin/list' => 'admin#list'
	match 'logout' => 'sessions#logout'

	match 'api/data4wp' => 'user#data_for_wp'

  	match ':controller(/:action(/:id(.:format)))'
end

