Rails.application.routes.draw do
  root 'homepage#show'

  resources :missions do
    resources :god_messages
  end

  resources :users
  match '/signup',  to: 'users#new', via: [:get]
  match '/signin',  to: 'sessions#new', via: [:get]
  match '/sessions',  to: 'sessions#create', via: [:post]
  match '/signout', to: 'sessions#destroy', via: [:get]

  match '/receive_sms', to: 'twilio#receive_sms', via: [:get, :post]
end
