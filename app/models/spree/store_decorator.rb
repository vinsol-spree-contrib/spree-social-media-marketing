Spree::Store.class_eval do
  has_many :social_media_accounts, class_name: 'Spree::SocialMediaAccount'
  has_many :twitter_accounts, class_name: "Spree::TwitterAccount"
  has_many :facebook_accounts, class_name: "Spree::FacebookAccount"
  has_many :facebook_pages, through: :facebook_accounts, source: :pages
end