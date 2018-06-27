module Spree
  module Admin
    module SocialMediaPostsHelper
      def get_all_social_media_accounts
        Spree::FacebookPage.all + Spree::TwitterAccount.all
      end

      def set_checked(id, accounts_array)
        accounts_array.include?(id) if accounts_array.present?
      end

      def display_account_name_with_social_platform(media_account)
        media_account.instance_of?(Spree::FacebookPage) ? "Facebook - #{ display_account_name(media_account) }" : "Twitter - #{ display_account_name(media_account) }"
      end

      def display_account_name(media_account)
        if media_account.instance_of?(Spree::FacebookPage)
          media_account.account.name + '/' + media_account.page_name
        else
          media_account.name
        end
      end
    end
  end
end
