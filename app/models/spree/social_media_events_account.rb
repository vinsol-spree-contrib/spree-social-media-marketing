module Spree
  class SocialMediaEventsAccount < ActiveRecord::Base
    belongs_to :social_media_marketing_event
    belongs_to :social_media_marketing_account, polymorphic: true

    def facebook?
      social_media_marketing_account_type == 'Spree::FacebookPage'
    end

    def twitter?
      social_media_marketing_account_type == 'Spree::SocialMediaAccount'
    end
  end
end
