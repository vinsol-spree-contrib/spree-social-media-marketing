require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-twitter'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.facebook_app_key, Rails.application.secrets.facebook_app_secret,
           :scope => 'email,publish_actions,publish_pages,manage_pages', :display => 'popup'
  provider :twitter, Rails.application.secrets.twitter_consumer_key, Rails.application.secrets.twitter_consumer_secret,
    {
      :secure_image_url => 'true',
      :image_size => 'original',
      :authorize_params => {
        :force_login => 'true'
      }
    }
end
