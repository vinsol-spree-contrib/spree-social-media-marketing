Rails.application.routes.draw do
end

Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :social_media_accounts
    resources :facebook_pages, only: [:create, :destroy]
  end

  get 'auth/:provider/callback', to: 'admin/social_media_accounts#create'
  get 'auth/facebook', to: 'auth#facebook'
  get 'auth/twitter', to: 'auth#twitter'
  get 'auth/failure', to: redirect('/')

end
