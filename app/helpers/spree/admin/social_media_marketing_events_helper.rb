module Spree
  module Admin
    module SocialMediaMarketingEventsHelper

      def display_account_name(event_account)
        if event_account.facebook?
          event_account.social_media_marketing_account.account.name + '/' + event_account.social_media_marketing_account.page_name
        else
          event_account.social_media_marketing_account.name
        end
      end
    end
  end
end
