Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  devise_for :company_users, path: 'company',
                             path_names: { sign_up: "register" },
                             controllers: { registrations: "company/registrations" },
                             skip: [:sessions, :passwords, :confirmations]

  devise_for :freelancers, path: 'freelancer',
                           path_names: { sign_up: "register" },
                           controllers: { registrations: "freelancer/registrations" },
                           skip: [:sessions, :passwords, :confirmations]

  root "main#index"

  get "freelance-service-agreement", to: "main#freelance_service_agreement"
  get "confirm_email", to: "main#confirm_email"
  get "job_country_currency", to: "main#job_countries", as: "job_country_currency"

  namespace :freelancer do

    root "main#index"
    resource :freelancer, only: [:show]

    resources :registration_steps, only: [:show, :update, :index] do
      member do
        post :skip
      end
    end

    resources :companies, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :av_companies, on: :collection
    end

    resources :jobs, only: [:index, :show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :my_jobs, on: :collection
      get :my_applications, on: :collection
      get :job_matches, on: :collection
      post :apply, on: :collection

      resources :application, only: [:index, :create]
      resource :contract, only: [:show, :accept], as: "work_order", path: "work_order"
      resources :messages, only: [:index, :create]
      # resources :payments, controller: "job_payments", only: [:index]
      resources :payments, controller: "job_payments", only: [:index, :show] do
        get :print, on: :member
        post :create_payment, on: :collection
      end
      resource :review, only: [:show, :create]
      resources :quotes, only: [:index, :create] do
        get :accept, on: :member
        get :decline, on: :member
      end

    end
    resource :profile, only: [:show, :edit, :update] do
      resource :banking, only: [:index, :edit, :update, :verify, :update_verify]
      resource :settings, only: [:index, :edit, :update]

    end
    resources :payments, only: [:index]

    get "profile/bank_info", to: "banking#index", as: "profile_stripe_banking_info"
    get "profile/identity", to: "banking#identity", as: "profile_stripe_banking"
    get "profile/bank_account", to: "banking#bank_account", as: "profile_stripe_bank_account"
    post "stripe/connect", to: "banking#connect", as: "stripe_connect"
    post "stripe/bank", to: "banking#add_bank_account", as: "stripe_bank_submit"
    get "profile/settings", to: "settings#index"
    post "jobs/:id", to: "jobs#apply"
    post "job/apply", to: "jobs#apply"
    get "jobs/:id/work_order/accept", to: "contracts#accept"
    get "job_payment/request", to: "job_payments#request_payout", as: "payout_request"

    resources :notifications

    resource :friend_invites, only: [:show, :update]

  end

  namespace :company do
    root "main#index"

    resource :profile, only: [:show, :edit, :update]
    resources :registration_steps, only: [:show, :update, :index] do
      member do
        post :skip
      end
    end

    resources :freelancers, only: [:index, :show] do
      get :hired, on: :collection
      get :favourites, on: :collection
      post :add_favourites, on: :collection
    end

    get "freelancers/:id/invite_to_quote", to: "freelancers#invite_to_quote"

    resources :applicants
    resources :payments
    resources :projects
    resources :subscription
      get 'thanks', to: 'subscription#thanks', as: 'thanks'
      get 'reset', to: 'subscription#reset_company', as: 'reset'
      get 'plans', to: 'subscription#plans', as: 'plans'
      get 'subscription_cancel', to: 'subscription#cancel', as: 'subscription_cancel'
      get 'subscription_change', to: 'subscription#change_plan', as: 'subscription_change'
      post 'subscription_checkout' => 'subscription#subscription_checkout'
      post 'update_card_info' => 'subscription#update_card_info'
      post 'webhooks' => 'subscription#webhooks'
      get 'plans/invoices', to: 'subscription#invoices', as: 'invoices'
      get 'plan/invoice', to: 'subscription#invoice', as: 'invoice'

    resources :notifications
    get 'job_country_currency', to: 'jobs#job_countries', as: 'job_country_currency'
    get '/:id/avj-invoice', to: 'jobs#avj_invoice', as: 'job_avj_invoice'
    get '/:id/print-avj-invoice', to: 'jobs#print_avj_invoice', as: 'job_avj_invoice_print'
    resources :jobs, except: [:index] do
      resources :job_build, only: [:index, :show, :update, :create] do
        member do
          post :skip
        end
      end
      resources :applicants do
        get :request_quote, on: :member
        get :ignore, on: :member
        resources :quotes, only: [:index, :create] do
          get :accept, on: :member
          get :decline, on: :member
        end
      end
      resource :contract, only: [:show, :edit, :update], as: "work_order", path: "work_order"
      resources :messages, only: [:index, :create]
      resources :payments, controller: "job_payments", only: [:index, :show] do
        get :print, on: :member
        post :mark_as_paid, on: :member
      end
      resource :review, only: [:show, :create]
      get :contract_invoice, on: :member
      get :freelancer_matches, on: :member
    end

    get "jobs/:id/publish", to: "jobs#publish"
  end

  namespace :admin do
    root "main#index"

    resources :freelancers, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resource :freelancer do
      get :download_csv
    end

    resources :companies, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
      get :jobs
    end

    resource :company do
      get :download_csv
    end

    resources :projects, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :jobs, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
      resources :applicants
      resource :contract, only: [:show, :edit, :update], as: "work_order", path: "work_order"
      resources :messages, only: [:index, :create]
      resources :payments, controller: "job_payments", only: [:index, :show]
      resource :review, only: [:show, :create]
    end

    resources :plans, except: [:new, :create] do
      get :disable, on: :member
      get :enable, on: :member
    end

    resources :pages, only: [:index, :edit, :update]
    resources :audits, only: [:index]

    resources :new_registrants, only: [:index]
  end

  get "*any", via: :all, to: "errors#not_found"
  get "*any", via: :all, to: "errors#unauthorized"
end
