module Spree
  module Admin
    class SocialMediaAccountsController < Spree::Admin::ResourceController

      def create
        account_uid = request.env['omniauth.auth']['uid']
        account_type = "Spree::#{request.env['omniauth.auth']['provider'].capitalize}Account"
        social_media_account = current_store.social_media_accounts.find_or_initialize_by(uid: account_uid, type: account_type).tap do |account|
          account.assign_attributes(get_media_account_fields)
        end
        if social_media_account.save
          flash[:success] = 'Account Saved'
        else
          flash[:error] = social_media_account.errors.full_messages.join('\n')
        end
        redirect_to admin_social_media_accounts_path
      end

      def show
        if @social_media_account.display_account_name == 'Twitter'
          @posts = @social_media_account.posts.order("created_at desc").page(params[:page]).per(params[:per_page])
        end
      end

      private
        def fetch_social_media
          unless @social_media_account = Spree::SocialMediaAccount.find_by(id: params[:id])
            flash[:alert] = 'Account Does Not Exist'
            redirect_to admin_social_media_accounts_path
          end
        end

        def get_media_account_fields()
          media_account_fields = { auth_token: request.env['omniauth.auth']['credentials']['token'],
                                   name: request.env['omniauth.auth']['info']['name']
                                 }
          if request.env['omniauth.auth']['provider'] == 'twitter'
            media_account_fields.merge!(auth_secret: request.env['omniauth.auth']['credentials']['secret'])
          end
            
          media_account_fields
        end
    end
  end
end
