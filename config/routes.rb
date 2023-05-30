Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # get '/tools', to: "tools#index", as: :tools
  # get '/tools/:id', to: "tools#"
  resources :tools, only: %i[index show update]
  post '/tools/:id', to: "tools#show", as: :tools_eq
end
