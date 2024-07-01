Rails.application.routes.draw do
  root "main#index"
  mount API::Base => "/"
end
