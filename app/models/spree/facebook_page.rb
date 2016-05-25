require 'koala'
module Spree
  class FacebookPage < ActiveRecord::Base

    belongs_to :account, class_name: 'Spree::FacebookAccount', foreign_key: :account_id
    has_many :posts, as: :social_media_postable, class_name: 'Spree::SocialMediaPost'

    validates :page_id, presence: true, uniqueness: {message: 'has already been added'}
    before_validation :get_and_assign_page_access_token

    attr_accessor :client

    def post(message, images = [])
      if images.present?
        image_binary = images[0].get_image_binary
        response = post_image(image_binary, message)
      else
        response = post_message(message)
      end
      response['id']
    end

    def remove_post(post_id)
      set_koala_client
      begin
        client.delete_object(post_id)
      rescue Koala::Facebook::ClientError => e
        Rails.logger.error("Facebook Remove Post Error For PostId: #{ post_id }\n#{ e.message }\n")
      end
    end

    private
      def set_koala_client
        self.client = Koala::Facebook::API.new(self.page_token)
      end

      def post_message(message)
        set_koala_client
        client.put_connections(self.page_id, 'feed', message: message)
      end

      def post_image(source_binary, caption = '')
        set_koala_client
        client.put_picture(source_binary, 'multipart/form-data', {message: caption}, self.page_id)
      end

      ## TODO: What is assing?(done)
      def get_and_assign_page_access_token
        page_access_token_uri = URI("https://graph.facebook.com/#{ page_id }")
        page_access_token_uri.query = URI.encode_www_form(access_token: account.auth_token, fields: 'access_token')
        response = Net::HTTP.get_response(page_access_token_uri)
        response_json = JSON.parse(response.body)
        if response.code == '200'
          self.page_token = response_json['access_token']
          set_koala_client
          self.page_name = client.get_page(self.page_id)['name']
        else
          errors.add(:base, "Could not add this page. Please check the page id again and make sure you have appropriate permisions for this page")
        end
      end
  end
end