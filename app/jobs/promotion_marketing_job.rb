class PromotionMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(promotion_id, marketing_event)
    promotion = Spree::Promotion.find_by(id: promotion_id)
    if promotion && !promotion.expired? && !promotion.marketed_at?
      facebook_message = promotion.get_social_marketing_message('facebook')
      twitter_message = promotion.get_social_marketing_message('twitter')
      Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(marketing_event, facebook_message, twitter_message)
      promotion.update(marketed_at: Time.current)
    end
  end
end
