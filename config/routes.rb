Rails.application.routes.draw do
  devise_for :company
  devise_for :freelancer
  devise_for :admins
  devise_for :users
  root "main#index"

  get "privacy-policy", to: "pages#show", id: "privacy-policy"
  get "terms-of-service", to: "pages#show", id: "terms-of-service"

  namespace :freelancer do
    root "freelancers#show"

    resource :freelancer, only: [:show, :edit, :update]
  end

  namespace :company do
    root "main#index"

    resource :profile, only: [:show, :edit, :update]
    resources :freelancers, only: [:index, :show] do
      get :hired, on: :collection
      get :favourites, on: :collection
      post :add_favourites, on: :collection
    end
    resources :applicants
    resources :payments
    resources :projects

    resources :jobs, except: [:index] do
      resources :applicants do
        get :request_quote, on: :member
        get :ignore, on: :member
        resources :quotes, only: [:index, :create] do
          get :accept, on: :member
          get :decline, on: :member
        end
      end
      resource :contract, only: [:show, :edit, :update]
      resources :messages, only: [:index, :create]
      resources :payments, controller: "job_payments", only: [:index, :show] do
        get :print, on: :member
        get :mark_as_paid, on: :member
      end
      resource :review, only: [:show, :create]
    end
  end

  namespace :admin do
    root "main#index"

    resources :freelancers, except: [:new, :create] do
      get :login_as, on: :member
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :companies, except: [:new, :create] do
      get :login_as, on: :member
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :pages, only: [:index, :edit, :update]
    resources :audits, only: [:index]
  end
end
