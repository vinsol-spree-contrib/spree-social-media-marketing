Spree::PaymentMethod.class_eval do
  include Spree::SocialMediaUrlHelpers

  Spree::PaymentMethod::MARKUP_ALLOWED_METHODS = [:name, :home_page]

  after_save :create_marketing_job, if: :active_and_active_changed?

  def get_social_marketing_message
    marketing_event = Spree::SocialMediaMarketingEvent.find_by(name: 'payment_method_creation')
    marketing_event.get_parsed_message(self)
  end
  private

    def active_and_active_changed?
      active? && active_changed?
    end

    def create_marketing_job
      if Spree::SocialMediaMarketingEvent.find_by(name: 'payment_method_creation').active?
        PaymentMethodMarketingJob.perform_later(self.id)
      end
    end
end