module Spree
  module Admin
    module SocialMediaPostsHelper
      def get_all_social_media_accounts
        Spree::FacebookPage.all + Spree::TwitterAccount.all
      end

      def display_account_name(media_account)
        if media_account.instance_of?(Spree::FacebookPage)
          'Facebook - ' + media_account.account.name + '/' + media_account.page_name
        else
          'Twitter -' + media_account.name
        end
      end
    end
  end
end
