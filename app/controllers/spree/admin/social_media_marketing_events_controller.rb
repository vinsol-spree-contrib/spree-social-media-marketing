module Spree
  module Admin
    class SocialMediaMarketingEventsController < Spree::Admin::ResourceController

      def create
      end

      def show
      end

      private

        def social_media_marketing_event_params
          params.require(:social_media_marketing_event).permit(:message, :active)
        end
    end
  end
end
