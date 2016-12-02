module Spree
  class SocialMediaPostingService

  # Post on facebook pages and twitter account. Message is required to post anything.
    def self.post_on_media_accounts(message, images = [])
      Spree::Store.default.social_media_accounts.each do |social_media_account|
        social_media_account.post(message, images)
      end
    end
  end
end