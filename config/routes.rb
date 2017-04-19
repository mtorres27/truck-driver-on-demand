Rails.application.routes.draw do
  root to: "main:index"

  get "/auth/:provider/callback", to: "sessions#create"
end
