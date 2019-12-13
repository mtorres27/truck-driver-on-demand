# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  devise_for :users, skip: [:registrations], controllers: { sessions: "sessions" }

  devise_for :company_users, path: "company",
                             path_names: { sign_up: "register" },
                             controllers: { registrations: "company/registrations", sessions: "sessions" },
                             skip: %i[devise passwords confirmations]

  devise_for :drivers, path: "driver",
                           path_names: { sign_up: "register" },
                           controllers: { registrations: "driver/registrations", sessions: "driver/sessions" },
                           skip: %i[devise passwords confirmations]

  devise_scope :company_user do
    match "active"            => "sessions#active",               via: :get
    match "timeout"           => "sessions#timeout",              via: :get
  end

  devise_scope :driver do
    match "active"                        => "sessions#active",                   via: :get
    match "timeout"                       => "sessions#timeout",                  via: :get
    match "phone_login"                   => "driver/sessions#phone_login",       via: :post
    match "send_login_code/:phone_number" => "driver/sessions#send_login_code",   via: :post
  end

  devise_scope :admin do
    match "active"            => "sessions#active",               via: :get
    match "timeout"           => "sessions#timeout",              via: :get
  end

  root "main#index"

  get "driver-service-agreement", to: "main#driver_service_agreement"
  get "confirm_email", to: "main#confirm_email"
  get "job_country_currency", to: "main#job_countries", as: "job_country_currency"

  match "/public_jobs" => "public_pages#public_jobs",   via: :get

  namespace :driver do
    root "main#index"
    resource :driver, only: [:show] do
      collection do
        post :request_verification
      end
    end

    resources :onboarding_process, only: %i[index] do
      get :complete_profile, on: :collection
      put :complete_profile_update, on: :collection
      get :cvor_abstract, on: :collection
      put :upload_cvor_abstract, on: :collection
      get :driver_abstract, on: :collection
      put :upload_driver_abstract, on: :collection
      get :resume, on: :collection
      put :upload_resume, on: :collection
      get :drivers_license, on: :collection
      put :upload_drivers_license, on: :collection
    end

    resources :employment_terms, only: %i[index] do
      get :health_and_safety, on: :collection
      put :accept_health_and_safety, on: :collection
      get :wsib, on: :collection
      put :accept_wsib, on: :collection
      get :excess_hours, on: :collection
      put :accept_excess_hours, on: :collection
      get :terms_and_conditions, on: :collection
      put :accept_terms_and_conditions, on: :collection
      get :previously_registered, on: :collection
      put :previously_registered_answer, on: :collection
    end

    resources :registration_steps, only: %i[show update index]

    resources :companies, only: %i[index show] do
      get :favourites, on: :collection
      post :add_favourites, on: :collection
      get :av_companies, on: :collection
      resources :messages, only: %i[index create]
    end

    resources :jobs, only: %i[index show]

    resource :profile, only: %i[show edit update] do
      resource :banking, only: %i[index edit update verify update_verify]
      resource :settings, only: %i[index edit update]
    end

    resources :messaging, only: [:index]

    get "profile/settings", to: "settings#index"
    post "jobs/:id", to: "jobs#apply"
    post "job/apply", to: "jobs#apply"
    get "jobs/:id/work_order/accept", to: "contracts#accept"
    get "companies/:company_id/messages(/job/:job_id)", to: "messages#index", as: "messages_for_job"
  end

  namespace :company do
    root "main#index"

    resource :profile, only: %i[show edit update]
    resources :registration_steps, only: %i[show update index] do
      member do
        post :previous
      end
    end

    resources :drivers, only: %i[show index] do
      get :saved, on: :collection
      get :hired, on: :collection
      post :add_favourites, on: :collection
      post :save_driver, on: :member
      post :delete_driver, on: :member
      resources :messages, only: %i[index create]
    end

    resources :company_users, only: %i[edit update]

    get "drivers/:id/invite_to_quote", to: "drivers#invite_to_quote"

    resources :applicants
    resources :messaging, only: [:index]

    get "job_country_currency", to: "jobs#job_countries", as: "job_country_currency"

    resources :jobs

    get "jobs/:id/publish", to: "jobs#publish"
    get "drivers/:driver_id/messages(/job/:job_id)", to: "messages#index", as: "messages_for_job"
  end

  namespace :admin do
    root "main#index"

    resources :drivers, except: %i[new create] do
      get :disable, on: :member
      get :enable, on: :member
      get :verify, on: :member
      get :unverify, on: :member
      get :messaging, on: :member
    end

    resource :driver do
      get :download_csv
    end

    resources :companies, except: %i[new create] do
      get :disable, on: :member
      get :enable, on: :member
      get :jobs
      get :messaging, on: :member
    end

    resource :company do
      get :download_csv
    end

    resources :jobs, except: %i[new create] do
      get :driver_matches, on: :member
      get :mark_as_expired, on: :member
      get :unmark_as_expired, on: :member
    end

    resources :new_registrants, only: [:index]
    resource :new_registrant, only: [:download_csv] do
      get :download_csv
    end

    resources :incomplete_registrations, only: [:index]
    resource :incomplete_registration, only: [:download_csv] do
      get :download_csv
    end

    resources :connections, only: [:index]

    get "companies/:company_id/messages/driver/:driver_id", to: "messages#index", as: "messages"
  end

  get "*any", via: :all, to: "errors#not_found"
  get "*any", via: :all, to: "errors#unauthorized"
end
