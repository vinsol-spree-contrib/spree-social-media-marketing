class PaymentMethodMarketingJob < ActiveJob::Base
  queue_as :social_marketing
 
  def perform(payment_method_id)
    payment_method = Spree::PaymentMethod.find_by(id: payment_method_id)
    if payment_method && payment_method.active?
      Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(payment_method.get_social_marketing_message)
    end
  end
end
