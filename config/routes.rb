Plutus::Engine.routes.draw do
  root :to => "accounts#index"

  resources :plutus_accounts
  resources :transactions
end