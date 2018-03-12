Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :social_media_accounts
    resources :social_media_marketing_events
    resources :facebook_pages, only: [:create, :destroy, :show]
    resources :social_media_posts, only: [:new, :create, :destroy] do
      member do
        put :repost
      end
    end
  end

  get 'auth/:provider/callback', to: 'admin/social_media_accounts#create', as: :oauth_redirect
  get 'auth/facebook', to: 'auth#facebook'
  get 'auth/twitter', to: 'auth#twitter'
  match 'auth/failure', to: redirect('/admin/social_media_accounts'), via: [:get, :post]

end
