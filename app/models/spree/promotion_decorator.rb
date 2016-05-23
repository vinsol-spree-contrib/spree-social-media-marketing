Spree::Promotion.class_eval do
  include Spree::Core::Engine.routes.url_helpers

  after_save :create_marketing_job, if: :starts_at_changed_and_is_present?

  def get_social_marketing_message
    "#{ self.description }. Checkout here #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
    # promotion_creation_marketing_event_message = Spree::SocialMediaMarketingEvent.find_by(name: 'promotion_creation').message
    # while match_data = promotion_creation_marketing_event_message.match(/(<.*?>)/)
    #   promotion_creation_marketing_event_message.sub!(/(<.*?>)/, (send(match_data[1][1, (match_data[1].length - 2)])) || '')
    # end
    # promotion_creation_marketing_event_message
  end

  # def root_url
  #   Spree::Core::Engine.routes.url_helpers.root_url(host: (Rails.application.config.action_mailer.default_url_options.try(:[], :host) || 'localhost:3000'))
  # end

  private

    def starts_at_changed_and_is_present?
      starts_at? && starts_at_changed?
    end

    def create_marketing_job
      PromotionMarketingJob.set(wait_until: self.starts_at).perform_later(self.id)
    end
end