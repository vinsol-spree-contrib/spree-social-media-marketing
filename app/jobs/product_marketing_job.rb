class ProductMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(product_id, marketing_event)
    product = Spree::Product.find_by(id: product_id)
    if product && product.available? && !product.marketed_at?
      facebook_message = product.get_social_marketing_message('facebook')
      twitter_message = product.get_social_marketing_message('twitter')
      Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(marketing_event, facebook_message, twitter_message, product.images)
      product.update(marketed_at: Time.current)
    end
  end
end
