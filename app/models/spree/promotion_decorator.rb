Spree::Promotion.class_eval do
  include Spree::Core::Engine.routes.url_helpers

  after_save :create_marketing_job, if: :starts_at_changed_and_is_present?

  def get_social_marketing_message
    "#{ self.description }. Checkout here #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
  end

  private

    def starts_at_changed_and_is_present?
      starts_at? && starts_at_changed?
    end

    def create_marketing_job
      PromotionMarketingJob.set(wait_until: self.starts_at).perform_later(self.id)
    end
end