Rails.application.routes.draw do
  root "main#index"

  get "/admin/dashboard" => "admin/dashboard#index"
  get "/admin" => "admin/login#new"
  post "/admin" => "admin/login#login"
  delete "/admin/logout" => "admin/login#logout"

  namespace :admin do
    resources :user_details
    resources :matches
    resources :leagues
    resources :news
  end
  mount API::Base => "/"
end
