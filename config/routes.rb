Rails.application.routes.draw do
  root "welcomes#index"
  get "/users", to: "welcomes#users_json"
end
