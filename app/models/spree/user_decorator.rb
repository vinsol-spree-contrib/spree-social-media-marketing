Spree.user_class.class_eval do

  Spree.user_class::MARKUP_ALLOWED_METHODS = [:customer_count, :home_page]

  after_create :check_if_any_milestone_reached

  def self.get_social_marketing_message(milestone = 0)
    marketing_event.get_parsed_message(self, { customer_count: milestone.to_s })
  end

  def self.customer_count
    (Spree.user_class.count - Spree.user_class.admin.count).to_s
  end

  def self.marketing_event
    @marketing_event ||= Spree::SocialMediaMarketingEvent.find_by(name: 'User Milestone')
  end
  private
    def check_if_any_milestone_reached
      user_count = Spree::user_class.customer_count
      if user_count == self.class.marketing_event.threshold
        schedule_marketing_notifications(user_count)
      end
    end

    def schedule_marketing_notifications(milestone)
      if self.class.marketing_event.active?
        UserMilestoneMarketingJob.perform_later(milestone)
      end
    end
end