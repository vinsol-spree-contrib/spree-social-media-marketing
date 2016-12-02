class PromotionMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(promotion_id)
    promotion = Spree::Promotion.find_by(id: promotion_id)
    if promotion && !promotion.expired? && !promotion.marketed_at?
      Spree::SocialMediaPostingService.post_on_media_accounts(promotion.get_social_marketing_message)
      promotion.update(marketed_at: Time.current)
    end
  end
end
