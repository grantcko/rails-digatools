Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :tools, only: %i[index show update]
  post '/equalize/', to: "tools#equalize_audio", as: :equalize
  get '/download', to: "tools#download", as: :download
end
