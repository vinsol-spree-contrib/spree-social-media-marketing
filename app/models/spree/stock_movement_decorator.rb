Spree::StockMovement.class_eval do
  include Spree::Core::Engine.routes.url_helpers

  after_create :check_total_stock

  def get_social_marketing_message(product_quantity)
    "Hurry up. #{ self.stock_item.variant.name } is selling fast. Only #{ product_quantity } left. Buy here #{ self.product_url(self.stock_item.variant.product.id, host: (Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3000')) }"
  end

  private

  def check_total_stock
    product_total_on_hand = self.stock_item.variant.product.total_on_hand
    if self.stock_item.variant.product.total_on_hand == 9
      LowStockProductMarketingJob.perform_later(self.id, product_total_on_hand)
    end
  end
end