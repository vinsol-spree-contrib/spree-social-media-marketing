require 'koala'
module Spree
  class FacebookPage < ActiveRecord::Base

    belongs_to :account, class_name: 'Spree::FacebookAccount', foreign_key: :account_id
    has_many :posts, as: :social_media_publishable, class_name: 'Spree::SocialMediaPost', dependent: :destroy

    validates :page_id, presence: true, uniqueness: { message: 'has already been added' }

    before_save :get_and_assign_page_access_token

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
      begin
        client.delete_object(post_id)
      rescue Koala::Facebook::ClientError => e
        Rails.logger.error("Facebook Remove Post Error For PostId: #{ post_id }\n#{ e.message }\n")
      end
    end

    private
      def client
        Koala::Facebook::API.new(page_token)
      end

      def post_message(message)
        client.put_connections(page_id, 'feed', message: message)
      end

      def post_image(source_binary, caption = '')
        client.put_picture(source_binary, 'multipart/form-data', {message: caption}, page_id)
      end

      def get_and_assign_page_access_token
        user_graph = Koala::Facebook::API.new(account.auth_token)
        self.page_token = user_graph.get_page_access_token(page_id)
        self.page_name = Koala::Facebook::API.new(page_token).get_page(page_id)['name']
      rescue Koala::Facebook::ClientError => e
        errors.add(:page_id, "Access token not issued for page due to error #{e.message}")
        Rails.logger.error("SocialMediaMarketing::SpreeFacebookPage::AssignPageToken Fails with error #{e.message}")
      end
  end
end
