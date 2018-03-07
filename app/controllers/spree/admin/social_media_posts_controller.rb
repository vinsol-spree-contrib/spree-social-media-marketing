module Spree
  module Admin
    class SocialMediaPostsController < Spree::Admin::ResourceController
      before_filter :fetch_post, only: [:destroy, :repost]

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
    end
  end
end
