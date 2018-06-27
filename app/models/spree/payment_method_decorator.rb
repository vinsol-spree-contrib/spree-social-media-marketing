Spree::PaymentMethod.class_eval do
  include Spree::SocialMediaUrlHelpers

  attr_accessor :create_job_for_marketing

  Spree::PaymentMethod::MARKUP_ALLOWED_METHODS = [:name, :home_page]

  after_create :create_marketing_job, if: :active_and_create_job_for_marketing?
  after_update :create_marketing_job, if: :active_and_active_changed?

  def get_social_marketing_message(type='facebook')
    marketing_event.get_parsed_message(self, type)
  end

  def marketing_event
    @marketing_event ||= Spree::SocialMediaMarketingEvent.find_by(name: 'Payment Method Creation')
  end

  private

    def active_and_create_job_for_marketing?
      active? && create_job_for_marketing
    end

    def active_and_active_changed?
      active? && active_changed?
    end

    def create_marketing_job
      if marketing_event && marketing_event.active?
        PaymentMethodMarketingJob.perform_later(self.id, marketing_event)
      end
    end
end
