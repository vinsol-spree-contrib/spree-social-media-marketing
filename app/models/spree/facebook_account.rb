module Spree
  class FacebookAccount < SocialMediaAccount

    has_many :pages, class_name: 'Spree::FacebookPage', foreign_key: :account_id, dependent: :destroy

    before_validation :get_and_assign_long_lived_access_token

    def post(message, images)
      self.pages.each do |facebook_page|
        facebook_page.post(message, images.first)
      end
    end

    private
      def get_and_assign_long_lived_access_token
        long_lived_user_access_token_uri = URI('https://graph.facebook.com/oauth/access_token')
        long_lived_user_access_token_uri.query = URI.encode_www_form(grant_type: 'fb_exchange_token', client_id: Rails.application.secrets.facebook_app_key, client_secret: Rails.application.secrets.facebook_app_secret, fb_exchange_token: self.auth_token)
        response = Net::HTTP.get_response(long_lived_user_access_token_uri)
        if response.code == '200'
          self.auth_token = response.body.match(/access_token=(.*)&?/)[1]
        else
          reponse_json = JSON.parse(response.body)
          errors.add(:base, response_json['error']['message'])
        end
      end
  end
end