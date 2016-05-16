Spree::Store.class_eval do
  has_many :social_media_accounts, class_name: 'Spree::SocialMediaAccount'
  
  Spree::SocialMediaAccount.types.each do |social_media_account_type|
    has_many "#{social_media_account_type.downcase}_accounts".to_sym, class_name: "Spree::#{ social_media_account_type }Account"
  end
  has_many :facebook_pages, through: :facebook_accounts, source: :pages
end