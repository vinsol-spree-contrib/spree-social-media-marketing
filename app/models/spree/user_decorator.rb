class << Spree.user_class
  include Spree::Core::Engine.routes.url_helpers
end

Spree.user_class.class_eval do

  Spree.user_class::MILESTONES = [5, 1000, 2000, 5000]

  after_create :check_if_any_milestone_reached

  def self.get_social_marketing_message(milestone)
    "Hurray. We have reached #{ milestone } users. Check out the store at #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
  end

  private
    def check_if_any_milestone_reached
      user_count = customer_count
      if user_count.in?(Spree.user_class::MILESTONES)
        milestone_reached(user_count)
      end
    end

    def milestone_reached(milestone)
      UserMilestoneMarketingJob.perform_later(milestone)
    end

    # This is placeholder method. Developers can override this to get the number of cutomers as per their app and roles.
    def customer_count
      Spree.user_class.count - Spree.user_class.admin.count
    end
end