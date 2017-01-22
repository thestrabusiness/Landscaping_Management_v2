Rails.application.routes.draw do
  resources :clients do
    resources :addresses, except: [:index]
  end
  resources :invoices do
    resources :invoice_items, except: [:index, :show]
  end
end
