Spree::Promotion.class_eval do
  include Spree::Core::Engine.routes.url_helpers

  after_save :create_marketing_job, if: :starts_at_changed_and_is_present?

  def post_on_facebook
    caption = "#{ self.description }. Checkout here #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
    Spree::Store.default.facebook_pages.each do |facebook_page|
      facebook_page.post_message(caption)
    end
  end

  def post_on_twitter
    tweet = "#{ self.description }. Checkout here #{ self.root_url(host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
    Spree::Store.default.twitter_accounts.each do |twitter_account|
      twitter_account.post_tweet(tweet)
    end
  end

  private

    def starts_at_changed_and_is_present?
      starts_at? && starts_at_changed?
    end

    def create_marketing_job
      PromotionMarketingJob.set(wait_until: self.starts_at).perform_later(self.id)
    end
end