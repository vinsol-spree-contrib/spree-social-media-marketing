Spree::StockMovement.class_eval do
  include Spree::SocialMediaUrlHelpers

  after_create :check_total_stock

  Spree::StockMovement::MARKUP_ALLOWED_METHODS = [:product_name, :product_quantity, :home_page, :product_page]
  Spree::StockMovement::LOW_STOCK_LIMIT = 9

  def get_social_marketing_message
    marketing_event = Spree::SocialMediaMarketingEvent.find_by(name: 'low_stock_products')
    marketing_event.get_parsed_message(self)
  end

  def product_name
    self.stock_item.variant.name if self.persisted?
  end

  def product_quantity
    self.stock_item.variant.product.total_on_hand if self.persisted?
  end

  def product_page
    product_url(self.stock_item.variant.product.id) if self.persisted?
  end

  private

  def check_total_stock
    product_total_on_hand = self.stock_item.variant.product.total_on_hand
    if Spree::SocialMediaMarketingEvent.find_by(name: 'low_stock_products').active? && self.stock_item.variant.product.total_on_hand == Spree::StockMovement::LOW_STOCK_LIMIT
      LowStockProductMarketingJob.perform_later(self.id, product_total_on_hand)
    end
  end
end