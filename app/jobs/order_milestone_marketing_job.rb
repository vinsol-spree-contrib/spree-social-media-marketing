class OrderMilestoneMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(milestone, marketing_event)
    facebook_message = Spree::Order.get_social_marketing_message('facebook', milestone)
    twitter_message = Spree::Order.get_social_marketing_message('twitter', milestone)
    Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(marketing_event, facebook_message, twitter_message, [])
  end
end
