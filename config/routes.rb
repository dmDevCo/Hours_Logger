HoursLogger::Application.routes.draw do
  
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
  
  
  
  post '/stats' => 'time_cards#stats'
  post '/' => 'time_cards#home'
  post '/cookies/new' => 'cookies#create'
  post '/login', to: 'sessions#create'
  
  root to: 'time_cards#index'
  
end
