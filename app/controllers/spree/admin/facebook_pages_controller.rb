module Spree
  module Admin
    class FacebookPagesController < Spree::Admin::ResourceController
      before_filter :fetch_account, only: [:create]
      before_filter :fetch_page, only: [:destroy, :show]

      ## TODO: Don't think we need these actions. Please see Spree::Admin::ResourceController
      def create
        facebook_page = @account.pages.build(facebook_page_params)
        if facebook_page.save
          ## TODO: Please use I18n everywhere.
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

      def show
        @posts = @page.posts.order("created_at desc").page(params[:page]).per(params[:per_page])
      end

      # def collection
      #   Spree::GiftCard.order("created_at desc").page(params[:page]).per(Spree::Config[:orders_per_page])
      # end

      private

        def fetch_account
          unless @account = Spree::FacebookAccount.find_by(id: params[:facebook_page][:account_id])
            flash[:alert] = 'Account Does Not Exist'
            ## Lets not use this. It has been deprecated in Rails 5.
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
