Spree::Order.class_eval do

  Spree::Order::MARKUP_ALLOWED_METHODS = [:completed_order_count, :home_page]

  after_save :check_if_any_milestone_reached

  def self.get_social_marketing_message(type='facebook', milestone = 0)
    marketing_event.get_parsed_message(self, type, { completed_order_count: milestone.to_s })
  end

  # This is placeholder method. Developers can override this to get the number of orders as per their app.
  def self.completed_order_count
    Spree::Order.complete.count.to_s
  end

  def self.marketing_event
    @marketing_event ||= Spree::SocialMediaMarketingEvent.find_by(name: 'Order Milestone')
  end

  private
    def check_if_any_milestone_reached
      completed_order_size = Spree::Order.completed_order_count
      if self.class.marketing_event && completed_order_size == self.class.marketing_event.threshold
        schedule_marketing_notifications(completed_order_size)
      end
    end

    def schedule_marketing_notifications(milestone)
      if self.class.marketing_event.active?
        OrderMilestoneMarketingJob.perform_later(milestone, self.class.marketing_event)
      end
    end
end
