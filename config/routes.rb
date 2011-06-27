BlendMarks::Application.routes.draw do
  get "error/index"
  get "coming/index"
  resources :coming
  resources :user_sessions
  resources :users
  resources :links

  match "login", :controller => "user_sessions", :action => "new"
  match "logout", :controller => "user_sessions", :action => "destroy"
  match "register", :controller => "users", :action => "new"
  match "error", :controller => "error", :action => "index"

  match 'forgotpassword', :controller => "users", :action => "forgotpassword"
  match 'resetpassword/:id', :controller => "users", :action => "resetpassword"

  match 'quickentry', :controller => "links", :action => "quickentry"

  match 'addlink', :controller => "links", :action => "create"

  match 'invitepeople', :controller => "users", :action => "invitepeople"
  match 'confirminvitation', :controller => "users", :action => "confirminvitation"

  match 'addtag', :controller => "links", :action => "addtag"
  match 'readmail', :controller => "links", :action => "readlinksfrommail"
  match 'sendnotification',:controller => "links" , :action => "sendnotification"
  match "subscribe", :controller => "coming", :action => "subscribe"

  match 'search/:criteria(/:pageindex)', :controller => "links", :action => "search"

  root :controller => "links", :action => "index"

  match '/', :controller => "links", :action => "index" , :constraints => {:subdomain => "blendmarks"}
  match '/', :controller => "coming", :action => "index"

  match 'links/index/:pageindex', :controller => "links", :action => "index"

  match ':controller/:action/:id'

  match 'tag/:tag(/:pageindex)', :controller => "links", :action => "tagfilter"
  
  match '/autocomplete', :controller => "links", :action => "tagautocomplete"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
