Rails.application.routes.draw do
  # resources :posts
  resources :dashes do
    resources :posts
  end

  root 'dashes#index'
end
