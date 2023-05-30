Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :tools, only: %i[index show update]
  post '/tools/:id', to: "tools#show", as: :tools_eq
  # get '/tools/:id/download', to: "tools#download", as: :tools_download
end
