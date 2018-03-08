class UserMilestoneMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(milestone)
    Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(Spree.user_class.get_social_marketing_message(milestone))
  end
end
