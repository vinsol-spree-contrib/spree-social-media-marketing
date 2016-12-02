class OrderMilestoneMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(milestone)
    Spree::SocialMediaPostingService.post_on_media_accounts(Spree::Order.get_social_marketing_message(milestone))
  end
end
