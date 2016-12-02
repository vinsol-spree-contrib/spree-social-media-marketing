Spree::Product.class_eval do
  include Spree::Core::Engine.routes.url_helpers

  after_save :create_marketing_job, if: :available_on_changed_and_is_present?

  def get_social_marketing_message
    "Hey there, we have launched a new product on our store. Check it out here #{ self.product_url(self.id, host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
  end

  private

    def available_on_changed_and_is_present?
      available_on? && available_on_changed?
    end

    def create_marketing_job
      ProductMarketingJob.set(wait_until: self.available_on).perform_later(self.id)
    end
end