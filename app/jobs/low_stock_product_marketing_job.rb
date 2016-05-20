class LowStockProductMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(stock_movement_id, product_quantity)
    if stock_movement = Spree::StockMovement.find_by(id: stock_movement_id)
      Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(stock_movement.get_social_marketing_message(product_quantity), stock_movement.stock_item.variant.images)
    end
  end
end
