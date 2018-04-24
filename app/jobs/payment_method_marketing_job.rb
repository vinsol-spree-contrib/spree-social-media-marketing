class PaymentMethodMarketingJob < ActiveJob::Base
  queue_as :social_marketing

  def perform(payment_method_id, marketing_event)
    payment_method = Spree::PaymentMethod.find_by(id: payment_method_id)
    if payment_method && payment_method.active?
      facebook_message = payment_method.get_social_marketing_message('facebook')
      twitter_message = payment_method.get_social_marketing_message('twitter')
      Spree::SocialMediaPostingService.create_post_and_send_on_media_accounts(marketing_event, facebook_message, twitter_message)
    end
  end
end
