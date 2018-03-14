module Spree
  class SocialMediaPost < Spree::Base

    attr_accessor :fb_message, :twitter_message

    ## TODO: Can we rename this to social_media_publishable? postable is no word.
    belongs_to :social_media_publishable, polymorphic: true
    belongs_to :user, class_name: 'Spree::User'
    has_many :social_media_post_images, dependent: :destroy
    has_many :images, through: :social_media_post_images

    ## TODO: Why is this limit present? Should be only for Twitter. Also, extract to a constant.(done)
    ## TODO: Add validations for presence of social_media_publishable
    validates :post_message, presence: true
    validates :post_message, length: { maximum: 280 }, if: :social_media_publishable_is_twitter_account?
    validates :social_media_publishable, presence: true
    accepts_nested_attributes_for :images

    after_create :send_post_and_assign_post_id
    after_destroy :destroy_post_on_social_media, unless: :destroyed_by_association

    def send_post_and_assign_post_id
      begin
        post_id = social_media_publishable.post(post_message, images)
        self.update(post_id: post_id, error_message: nil)
      rescue StandardError => e
        self.update(error_message: e.message)
      end
    end

    def truncate_message_length
      self.post_message = post_message.truncate(280)
    end

    private
      def destroy_post_on_social_media
        social_media_publishable.remove_post(post_id) if post_id?
      end

      def social_media_publishable_is_twitter_account?
        social_media_publishable.class == Spree::TwitterAccount
      end
  end
end
