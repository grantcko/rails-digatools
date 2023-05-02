Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get '/tools', to: "tools#index", as: :tools
end
