module Spree
  module Admin
    class SocialMediaMarketingEventsController < Spree::Admin::ResourceController
      helper 'spree/admin/social_media_marketing_events'

      def edit
        @social_media_marketing_event.unlinked_social_media_accounts.each do |account|
          @social_media_marketing_event.social_media_events_accounts.build(social_media_marketing_account: account)
        end
      end

      def create
      end

      def show
      end

      private

        def social_media_marketing_event_params
          params.require(:social_media_marketing_event).permit(:message, :active, :threshold)
        end
    end
  end
end
