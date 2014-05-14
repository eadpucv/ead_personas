Persons::Application.routes.draw do
  scope "/personas" do
  	root :to => "usuarios#index"
    	match '/auth/:provider/callback' => 'authentications#create'   
  	match ':controller(/:action(/:id(.:format)))'
  end

  root :to => "others#index"
  
  match ':controller(/:action(/:id(.:format)))'


end

