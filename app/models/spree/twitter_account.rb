module Spree
  class TwitterAccount < SocialMediaAccount
    require 'twitter'
    attr_accessor :client

    after_initialize :set_twitter_account

    def post(tweet, images)
      if images.present?
        first_four_images = images[0, 4]
        image_ids = []
        image_binaries = first_four_images.map(&:get_image_binary)
        image_binaries.each do |image_binary|
          image_id = upload_media(image_binary)
          image_ids << image_id
        end
        post_tweet(tweet, media_ids: image_ids.join(','))
      else
        post_tweet(tweet)
      end
    end

    private
      def post_tweet(tweet, options = {})
        client.update(tweet, options)
      end

      def upload_media(media)
        client.upload(media)
      end

      def set_twitter_account
        self.client = Twitter::REST::Client.new do |config|
          config.consumer_key        = Rails.application.secrets.twitter_consumer_key
          config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
          config.access_token        = auth_token
          config.access_token_secret = auth_secret
        end
      end
  end
end