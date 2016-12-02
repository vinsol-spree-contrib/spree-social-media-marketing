class << Spree::PaymentMethod
  include Spree::Core::Engine.routes.url_helpers
end


Spree::PaymentMethod.class_eval do
  include Spree::Core::Engine.routes.url_helpers

  after_save :create_marketing_job, if: :active_and_active_changed?

  def get_social_marketing_message
    "Hey there, we have activated a new payment method on our store. You can now pay by #{ self.name }. Check out the store at #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
  end

  private

    def active_and_active_changed?
      active? && active_changed?
    end

    def create_marketing_job
      PaymentMethodMarketingJob.perform_later(self.id)
    end
end