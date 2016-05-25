Spree::Order.class_eval do
  extend Spree::SocialMediaUrlHelpers

  Spree::Order::MARKUP_ALLOWED_METHODS = [:completed_order_count, :home_page]
  Spree::Order::MILESTONES = [1000, 2000, 5000]

  after_save :check_if_any_milestone_reached

  def self.get_social_marketing_message(milestone = 0)
    marketing_event = Spree::SocialMediaMarketingEvent.find_by(name: 'order_milestone')
    marketing_event.get_parsed_message(self, { completed_order_count: milestone.to_s })
  end

  # This is placeholder method. Developers can override this to get the number of orders as per their app.
  def self.completed_order_count
    Spree::Order.complete.count.to_s
  end

  private
    def check_if_any_milestone_reached
      completed_order_size = Spree::Order.completed_order_count
      if completed_order_size.in?(Spree::Order::MILESTONES)
        milestone_reached(completed_order_size)
      end
    end

    def milestone_reached(milestone)
      if Spree::SocialMediaMarketingEvent.find_by(name: 'order_milestone').active?
        OrderMilestoneMarketingJob.perform_later(milestone)
      end
    end  
end