module Spree
  class SocialMediaPostingService

    # Post on facebook pages and twitter account. Message is required to post anything.
    def self.create_post_and_send_on_media_accounts(message, images = [])
      Spree::Store.default.social_media_accounts.each do |social_media_account|
        if social_media_account.type == 'Spree::FacebookAccount'
          social_media_account.pages.each do |facebook_page|
            post = facebook_page.posts.build(post_message: message)
            post.images = images[0, 1]
            post.save
          end
        else
          post = social_media_account.posts.build(post_message: message)
          post.images = images
          post.save
        end
      end
    end
  end
end
