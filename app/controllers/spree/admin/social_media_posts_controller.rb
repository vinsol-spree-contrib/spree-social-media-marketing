module Spree
  module Admin
    class SocialMediaPostsController < Spree::Admin::ResourceController
      before_filter :fetch_post, only: [:destroy, :repost]

      def new
        @post = Spree::SocialMediaPost.new
      end

      def create
        @social_media_post = Spree::SocialMediaPost.new(post_params)

        ## TODO: We don't need .present(done)
        if params[:social_media_post][:image]
          @social_media_post.images.build(post_image_params)
        end

        if @social_media_post.save
          flash[:success] = 'Post Added'
        else
          flash[:error] = @social_media_post.errors.full_messages.join(', ')
        end
        redirect_to :back
      end

      def destroy
        if @post.destroy
          flash[:success] = 'Post Removed'
        else
          flash[:error] = 'Could Not Remove Post'
        end
        redirect_to :back
      end

      def repost
        @post.send_post_and_assign_post_id
        redirect_to :back
      end

      def create_with_account
        @social_media_post_ids = []
        @errors = []
        if params[:social_media_publishable].blank?
          flash[:error] = 'Please select accounts'
        else
          build_posts_with_social_media_account('facebook_page') if params[:social_media_publishable][:facebook_page]
          build_posts_with_social_media_account('twitter_account') if params[:social_media_publishable][:twitter_account]
          if @errors.empty?
            flash[:success] =  'Post Added'
          else
            flash[:error] = @errors.uniq.join(', ')
          end
        end
        redirect_to :back
      end

      private

        def fetch_post
          unless @post = Spree::SocialMediaPost.find_by(id: params[:id])
            flash[:alert] = 'Post Does Not Exist'
            redirect_to :back
          end
        end

        def post_params
          params.require(:social_media_post).permit(:post_message, :social_media_publishable_id, :social_media_publishable_type).merge(user_id: try_spree_current_user.id)
        end

        def post_image_params
          params.require(:social_media_post).require(:image).permit(:attachment)
        end

        def social_media_account_params(social_media)
          params.require(:social_media_publishable).require(social_media)
        end

        def build_post_and_post_images
          @social_media_post = Spree::SocialMediaPost.new(post_params)
          if params[:social_media_post][:image]
            @social_media_post.images.build(post_image_params)
          end
        end

        def build_posts_with_social_media_account(social_media)
          social_media_account_params(social_media).each do |id|
            build_post_and_post_images
            social_media.eql?('facebook_page') ? set_fb_params(id) : set_twitter_params(id)
            if @social_media_post.save
              @social_media_post_ids << @social_media_post.id
            else
              @errors << @social_media_post.errors.full_messages.join(', ')
            end
          end
        end

        def set_fb_params(account_id)
          @social_media_post.social_media_publishable = Spree::FacebookPage.find(account_id)
          @social_media_post.post_message = params[:social_media_post][:fb_message]
        end

        def set_twitter_params(account_id)
          @social_media_post.social_media_publishable = Spree::TwitterAccount.find(account_id)
          @social_media_post.post_message = params[:social_media_post][:twitter_message]
          @social_media_post.truncate_message_length
        end
    end
  end
end
