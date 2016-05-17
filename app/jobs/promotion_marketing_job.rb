class PromotionMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(promotion_id)
    promotion = Spree::Promotion.find_by(id: promotion_id)
    if promotion && !promotion.expired? && !promotion.marketed_at?
      promotion.post_on_facebook
      promotion.post_on_twitter
      promotion.update(marketed_at: Time.current)
    end
  end
end
