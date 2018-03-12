module Spree
  class SocialMediaPostingService

    # Post on facebook pages and twitter account. Message is required to post anything.
    def self.create_post_and_send_on_media_accounts(marketing_event, fb_message, twitter_message, images = [])
      marketing_event.facebook_accounts.each do |facebook_page|
        post = facebook_page.posts.build(post_message: fb_message)
        post.images = images[0, 1]
        post.save
      end
      marketing_event.twitter_accounts.each do |twitter_account|
        post = twitter_account.posts.build(post_message: twitter_message)
        post.images = images
        post.save
      end
    end
  end
end
