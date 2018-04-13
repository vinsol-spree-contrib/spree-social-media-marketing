module Spree
  module Admin
    class SocialMediaPostsController < Spree::Admin::ResourceController
      before_action :fetch_post, only: [:destroy, :repost]
      before_action :check_social_media_accounts, only: :create_with_account

      def new
        @post = Spree::SocialMediaPost.new
      end

      def create
        @social_media_post = Spree::SocialMediaPost.new(post_params)

        ## TODO: We don't need .present(done)
        if params[:social_media_post][:post_image]
          @social_media_post.images.build(post_image_params)
        end

        if @social_media_post.save
          flash[:success] = 'Post Added'
        else
          flash[:error] = @social_media_post.errors.full_messages.join(', ')
        end
        redirect_back fallback_location: root_path
      end

      def destroy
        if @post.destroy
          flash[:success] = 'Post Removed'
        else
          flash[:error] = 'Could Not Remove Post'
        end
        redirect_back fallback_location: root_path
      end

      def repost
        @post.send_post_and_assign_post_id
        redirect_back fallback_location: root_path
      end

      def create_with_account
        @post = Spree::SocialMediaPost.new(post_with_account_params)
        @post.images.build(post_image_params) if params[:social_media_post][:post_image]
        response = @post.create_fb_twitter_posts
        if response.instance_of?(ActiveModel::Errors)
          flash[:error] = response.full_messages.join(', ')
          render :new
        else
          flash[:success] = 'Post Added'
          redirect_to new_admin_social_media_post_path
        end
      end

      private

        def fetch_post
          unless @post = Spree::SocialMediaPost.find_by(id: params[:id])
            flash[:alert] = 'Post Does Not Exist'
            redirect_back fallback_location: root_path
          end
        end

        def post_params
          params.require(:social_media_post).permit(:post_message, :social_media_publishable_id, :social_media_publishable_type).merge(user_id: try_spree_current_user.id)
        end

        def post_with_account_params
          params.require(:social_media_post).permit(:post_message, :social_media_publishable_id, :social_media_publishable_type, :fb_message, :twitter_message, fb_accounts: [], twitter_accounts: []).merge(user_id: try_spree_current_user.id)
        end

        def post_image_params
          params.require(:social_media_post).require(:post_image).permit(:attachment)
        end

        def post_fb_accounts_params
          params.require(:social_media_post).permit(fb_accounts: [])
        end

        def post_twitter_accounts_params
          params.require(:social_media_post).permit(twitter_accounts: [])
        end

        def check_social_media_accounts
          if post_fb_accounts_params.empty? && post_twitter_accounts_params.empty?
            flash[:error] = 'Please select accounts'
            render :new
          end
        end
    end
  end
end
