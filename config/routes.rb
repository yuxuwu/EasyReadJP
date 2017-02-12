Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:"pages#home"
  get "print_score", to: "pages#print_score"
  post '/pages', to: 'pages#getURLText'
  resources :pages
end