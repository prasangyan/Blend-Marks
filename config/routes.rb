BlendMarks::Application.routes.draw do
  get "error/index"

  get "coming/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
    resources :coming
    resources :user_sessions
    resources :users
    resources :links

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

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


  match 'search/:criteria', :controller => "links", :action => "search"
  #root :controller => "links", :action => "index"

  match '/', :controller => "links", :action => "index" , :constraints => {:subdomain => "blendmarks"}
  #match '/', :controller => "coming", :action => "index"

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'

  match 'search/:criteria', :controller => "links", :action => "search"
  match 'search/:criteria/:pageindex', :controller => "links", :action => "search"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
