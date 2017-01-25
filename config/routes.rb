Rails.application.routes.draw do
  resources :clients
  resources :addresses, except: [:index]
  resources :invoices do
    resources :invoice_items, except: [:index, :show]
  end
end
