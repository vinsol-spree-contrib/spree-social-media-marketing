class UserMilestoneMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(milestone)
    Spree::user_class.advertise_milestone_on_facebook(milestone)
    Spree::user_class.advertise_milestone_on_twitter(milestone)
  end
end
