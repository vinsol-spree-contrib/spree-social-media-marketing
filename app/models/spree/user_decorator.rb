Spree.user_class.class_eval do
  extend Spree::SocialMediaUrlHelpers

  Spree.user_class::PROMOTIONAL_MILESTONES = [5, 1000, 2000, 5000]
  Spree.user_class::MARKUP_ALLOWED_METHODS = [:customer_count, :home_page]

  after_create :check_if_any_milestone_reached

  def self.get_social_marketing_message(milestone = 0)
    marketing_event = Spree::SocialMediaMarketingEvent.find_by(name: 'user_milestone')
    marketing_event.get_parsed_message(self, { customer_count: milestone.to_s })
  end

  def self.customer_count
    (Spree.user_class.count - Spree.user_class.admin.count).to_s
  end
  private
    def check_if_any_milestone_reached
      user_count = Spree::user_class.customer_count
      if user_count.in?(Spree.user_class::PROMOTIONAL_MILESTONES)
        schedule_marketing_notifications(user_count)
      end
    end

    def schedule_marketing_notifications(milestone)
      if Spree::SocialMediaMarketingEvent.find_by(name: 'user_milestone').active?
        UserMilestoneMarketingJob.perform_later(milestone)
      end
    end
end