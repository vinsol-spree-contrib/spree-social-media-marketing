Spree::Product.class_eval do
  # delegate :url_helpers, to: 'Rails.application.routes' 

  # include Rails.application.routes.url_helpers
  # include ActionDispatch::Routing::UrlFor
  # include Rails.application.routes.url_helpers
  include Spree::Core::Engine.routes.url_helpers

  # has_one :job, as: :marketable, class_name: 'Spree::Job', dependent: :destroy

  after_save :create_marketing_job, if: :available_on_changed_and_is_present?

  def post_on_facebook
    caption = "Hey there, we have launched a new product on our store. Check it out here #{ self.product_url(self.id, host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
    if self.images.exists?
      first_image_binary = self.images.first.get_image_binary
      Spree::Store.default.facebook_pages.each do |facebook_page|
        facebook_page.post_image(first_image_binary, caption)
      end
    else
      Spree::Store.default.facebook_pages.each do |facebook_page|
        facebook_page.post_message(caption)
      end
    end
  end

  def post_on_twitter
    tweet = "Hey there, we have launched a new product on our store. Check it out here #{ self.product_url(self.id, host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
    Spree::Store.default.twitter_accounts.each do |twitter_account|
      twitter_account.tweet_with_images(tweet, self.images.limit(4))
    end
  end

  private

    def available_on_changed_and_is_present?
      available_on? && available_on_changed?
    end

    def create_marketing_job
      ProductMarketingJob.set(wait_until: self.available_on).perform_later(self.id)
    end
end