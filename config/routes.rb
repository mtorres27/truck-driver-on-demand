Rails.application.routes.draw do
  root "main#index"

  get "auth/:provider/callback", to: "sessions#create"
  resource :session, only: [:new, :create, :destroy]

  namespace :freelancer do
    root "freelancers#show"

    resource :freelancer, only: [:show, :edit, :update]
  end

  namespace :company do
    root "companies#show"

    resource :company, only: [:show, :edit, :update]
  end

  namespace :admin do
    root "freelancers#index"

    resources :freelancers, except: [:new, :create] do
      get :sign_in_as, on: :member
    end
  end
end
