class LowStockProductMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(stock_movement_id, product_quantity, marketing_event)
    if stock_movement = Spree::StockMovement.find_by(id: stock_movement_id)
      facebook_message = stock_movement.get_social_marketing_message('facebook', product_quantity)
      twitter_message = stock_movement.get_social_marketing_message('twitter', product_quantity)
      Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(marketing_event, facebook_message, twitter_message, stock_movement.stock_item.variant.images)
    end
  end
end
