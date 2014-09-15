HoursLogger::Application.routes.draw do
  
  resources :settings

  get '/' => 'time_cards#index'
  get '/time_cards/email' => 'time_cards#email'
  get '/login', to: 'sessions#new', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  resources :sessions, only: [:create]
  
  get "/signup", to: 'users#new', as: 'signup'
  resources :users

  get '/time_cards/:time', to: 'time_cards#stats', as: 'time_cards_by' # TODO this is so that you can do something like this: time_cards_by_path(:stats)
  
  resources :time_cards

  # get "/month" => 'time_cards#month'
  # get "/year" => 'time_cards#year'
  # get "/all" => 'time_cards#all'
  # get '/stats' => 'time_cards#stats'
  
  
 
  post '/stats' => 'time_cards#stats', as: 'stats'
  post '/' => 'time_cards#index'
  post '/cookies/new' => 'cookies#create'
  post '/login', to: 'sessions#create'
  post '/time_cards/email' => 'time_cards#email'
  post '/email' => 'time_careds#email_timer', as: 'email'
 

  get '/stats' => 'time_cards#stats'
  get '/email' => 'time_cards#email_timer'
 
  
  root to: 'time_cards#index'
  
  

end
