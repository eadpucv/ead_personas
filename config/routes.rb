Persons::Application.routes.draw do
  root :to => "others#index"
  match ':controller(/:action(/:id(.:format)))'
end

