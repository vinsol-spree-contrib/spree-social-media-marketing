module Spree
  module Admin
    class FacebookPagesController < Spree::Admin::ResourceController
      before_filter :fetch_account, only: [:create]
      before_filter :fetch_page, only: [:destroy]

      def create
        facebook_page = @account.pages.build(facebook_page_params)
        if facebook_page.save
          flash[:success] = 'Page Added'
        else
          flash[:error] = facebook_page.errors.full_messages.join('\n')
        end
          redirect_to admin_social_media_account_path(@account)
      end

      def destroy
        if @page.destroy
          flash[:success] = 'Page Removed'
        else
          flash[:alert] = 'Could Not Remove Page'
        end
        redirect_to :back
      end

      private

        def fetch_account
          unless @account = Spree::FacebookAccount.find_by(id: params[:facebook_page][:account_id])
            flash[:alert] = 'Account Does Not Exist'
            redirect_to :back
          end
        end

        def fetch_page
          unless @page = Spree::FacebookPage.find_by(id: params[:id])
            flash[:alert] = 'Page Does Not Exist'
            redirect_to :back
          end
        end

        def facebook_page_params
          params.require(:facebook_page).permit(:page_id)
        end
    end
  end
end
