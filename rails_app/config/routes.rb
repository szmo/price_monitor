Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index'

  post '/search', to: 'deals#search'
  resources :deals, only: [:index, :show]

end
