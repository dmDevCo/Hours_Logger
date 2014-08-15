HoursLogger::Application.routes.draw do
  get "cookies/new"
  get "cookies/create"
  get "cookies/destroy"
  resources :users

  resources :time_cards
  
  root :to => 'time_cards#home', :as => 'hours_logger'

  
  controller :cookies do
	get 'login' => :new
	post 'login' => :create
	delete 'logout' => :destroy
  end
  
  

  get "/month" => 'time_cards#month'
  get "/year" => 'time_cards#year'
  get "/all" => 'time_cards#all'
  get '/stats' => 'time_cards#stats'
  get "/signup" => "users#signup"
  
  post '/stats' => 'time_cards#stats'
  post '/' => 'time_cards#home'
  post '/cookies/new' => 'cookies#create'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
