Rails.application.routes.draw do
  resources :clients do
    resources :addresses, only: [:new, :create, :edit, :update]
    resources :invoices, only: [:new, :create]
  end
  resources :addresses, only: [:index] do
    resources :service_prices, except: [:index, :show]
  end
  resources :invoices, except: [:create] do
    resources :invoice_items, except: [:index, :show]
  end
  resources :services
  resources :estimates do
    resources :estimate_items, except: [:index, :show]
  end
  resources :payments

  root 'clients#index'
end
