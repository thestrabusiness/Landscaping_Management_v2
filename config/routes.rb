Rails.application.routes.draw do

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]
  resources :clients do
    resources :addresses, only: [:new, :create, :edit, :update]
    resources :invoices, only: [:new, :create]
    get :reminders, on: :collection
  end

  resources :addresses, only: [] do
    resources :service_prices, except: [:index, :show]
  end

  resources :invoices do
    resources :invoice_items, except: [:index, :show, :edit]

    member do
      get :download_pdf
    end

    collection do
      get :download_pdf_collection
      get :download_labels
    end
  end

  resources :services, except: [:edit, :update]

  resources :estimates do
    resources :estimate_items, except: [:index, :show, :edit]

    member do
      get :download_pdf
    end

    collection do
      get :download_pdf_collection
    end
  end

  resources :payments, except: :show

  root 'sessions#new'
end
