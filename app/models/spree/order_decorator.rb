class << Spree::Order
  include Spree::Core::Engine.routes.url_helpers
end

Spree::Order.class_eval do

  Spree::Order::MILESTONES = [1000, 2000, 5000]

  after_save :check_if_any_milestone_reached

  def self.get_social_marketing_message(milestone)
    "Hurray. We have reached #{ milestone } orders. Check out the store at #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
  end

  private
    def check_if_any_milestone_reached
      completed_order_count = get_completed_order_count
      if completed_order_count.in?(Spree::Order::MILESTONES)
        milestone_reached(completed_order_count)
      end
      completed_order_count.in?(Spree::Order::MILESTONES)
    end

    def milestone_reached(milestone)
      OrderMilestoneMarketingJob.perform_later(milestone)
    end

    # This is placeholder method. Developers can override this to get the number of orders as per their app.
    def get_completed_order_count
      Spree::Order.complete.count
    end
end