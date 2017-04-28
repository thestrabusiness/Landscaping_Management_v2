Rails.application.routes.draw do

  resources :clients do
    resources :addresses, only: [:new, :create, :edit, :update]
    resources :invoices, only: [:new, :create]
  end

  resources :addresses, only: [] do
    resources :service_prices, except: [:index, :show]
  end

  resources :invoices do
    resources :invoice_items, except: [:index, :show, :edit]
  end

  resources :services, except: [:edit, :update]

  resources :estimates do
    resources :estimate_items, except: [:index, :show, :edit]
  end

  resources :payments

  root 'clients#index'
end
