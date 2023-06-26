Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :tools, only: %i[index show create update destroy]
  post '/equalize', to: "tools#equalize_audio", as: :equalize
  get '/download', to: "tools#download", as: :download
  post '/generate_prompt', to: "tools#generate_prompt", as: :prompt
end
