module Spree
  class TwitterAccount < SocialMediaAccount
    require 'twitter'
    attr_accessor :client

    after_initialize :set_twitter_account

    # def initialize
    #   super
    #   self.client = Twitter::REST::Client.new do |config|
    #     config.consumer_key        = Rails.application.secrets.twitter_consumer_key
    #     config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
    #     config.access_token        = auth_token
    #     config.access_token_secret = auth_secret
    #   end
    # end

    def post_message(tweet, options = {})
      client.update(tweet, options)
    end

    def post_media(media)
      client.upload(media)
    end

    def post_with_medias(tweet, images)
      media_id = post_media(media)
      post_message(tweet, media_ids: media_id)
    end

    private
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