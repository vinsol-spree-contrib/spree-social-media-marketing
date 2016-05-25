Spree::Promotion.class_eval do
  include Spree::SocialMediaUrlHelpers

  Spree::Promotion::MARKUP_ALLOWED_METHODS = [:name, :description, :home_page]

  after_save :create_marketing_job, if: :starts_at_changed_and_is_present?

  def get_social_marketing_message
    marketing_event = Spree::SocialMediaMarketingEvent.find_by(name: 'promotion_creation')
    marketing_event.get_parsed_message(self)
  end

  private

    def starts_at_changed_and_is_present?
      starts_at? && starts_at_changed?
    end

    def create_marketing_job
      if Spree::SocialMediaMarketingEvent.find_by(name: 'promotion_creation').active?
        PromotionMarketingJob.set(wait_until: self.starts_at).perform_later(self.id)
      end
    end
end