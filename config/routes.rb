Rails.application.routes.draw do
  devise_for :companies, path: 'company', path_names: { sign_in: "login", sign_up: "register" }
  devise_for :freelancers, path: 'freelancer', path_names: { sign_in: "login", sign_up: "register" }
  devise_for :admins


  root "main#index"

  get "company/login", to: "devise/session#new"
  get "privacy-policy", to: "pages#show", id: "privacy-policy"
  get "terms-of-service", to: "pages#show", id: "terms-of-service"

  namespace :freelancer do
    root "main#index"
    resource :freelancer, only: [:show, :edit, :update]

    resources :companies, only: [:index, :show] do
      get :worked_for, on: :collection
      get :favourites, on: :collection
      post :add_favourites, on: :collection
    end

    resources :jobs, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
    end

    resources :notifications

    # resources :jobs, except: [:index] do
    #   resource :contract, only: [:show]
    #   resources :messages, only: [:index, :create]
    #   resources :payments, controller: "job_payments", only: [:index, :show] do
    #     get :print, on: :member
    #     get :request_payment, on: :member
    #   end
    #   resource :review, only: [:show, :create]
    # end


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
    resources :charges
      get 'thanks', to: 'charges#thanks', as: 'thanks'
      get 'plans', to: 'charges#plans', as: 'plans'
      post 'subscription_checkout' => 'charges#subscription_checkout'
      post 'webhooks' => 'charges#webhooks'

    resources :notifications

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
