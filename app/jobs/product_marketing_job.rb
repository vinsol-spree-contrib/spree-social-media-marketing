class ProductMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(product_id)
    product = Spree::Product.find_by(id: product_id)
    if product && product.available? && !product.marketed_at?
      Spree::SocialMediaPostingService.post_on_media_accounts(product.get_social_marketing_message, product.images)
      product.update(marketed_at: Time.current)
    end
  end
end
