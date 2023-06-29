Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get '/tools/demos', to: "tools#demo_index", as: :demos
  get '/tools/demos/:internal', to: "tools#demo_show", as: :demo
  resources :tools, only: %i[index show create new update destroy]
  post '/equalize', to: "tools#equalize_audio", as: :equalize
  get '/download', to: "tools#download", as: :download
end
