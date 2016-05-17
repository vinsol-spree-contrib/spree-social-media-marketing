class ProductMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(product_id)
    product = Spree::Product.find_by(id: product_id)
    if product && product.available? && !product.marketed_at?
      product.post_on_facebook
      product.post_on_twitter
      product.update(marketed_at: Time.current)
    end
  end
end
