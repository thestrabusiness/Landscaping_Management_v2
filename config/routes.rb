Rails.application.routes.draw do
  resources :clients
  resources :addresses, except: [:index] do
    resources :service_prices, except: [:index, :show]
  end
  resources :invoices do
    resources :invoice_items, except: [:index, :show]
  end
  resources :services
  resources :estimates do
    resources :estimate_items, except: [:index, :show]
  end
  resources :payments
end
