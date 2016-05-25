Spree::Product.class_eval do
  include Spree::SocialMediaUrlHelpers

  Spree::Product::MARKUP_ALLOWED_METHODS = [:name, :description, :home_page, :product_page]

  after_save :create_marketing_job, if: :available_on_changed_and_is_present?

  def get_social_marketing_message
    marketing_event = Spree::SocialMediaMarketingEvent.find_by(name: 'product_creation')
    marketing_event.get_parsed_message(self)
  end

  def product_page
    product_url(self.id) if self.persisted?
  end

  private
    def available_on_changed_and_is_present?
      available_on? && available_on_changed?
    end

    def create_marketing_job
      if Spree::SocialMediaMarketingEvent.find_by(name: 'product_creation').active?
        ProductMarketingJob.set(wait_until: self.available_on).perform_later(self.id)
      end
    end
end