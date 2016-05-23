module Spree
  class SocialMediaPost < ActiveRecord::Base
    belongs_to :social_media_postable, polymorphic: true
    has_many :social_media_post_images, dependent: :destroy
    has_many :images, through: :social_media_post_images

    validates :post_message, presence: true, length: { maximum: 140 }

    accepts_nested_attributes_for :images

    after_create :send_post_and_assign_post_id
    after_destroy :destroy_post_on_social_media

    private
      def send_post_and_assign_post_id
        self.update(post_id: social_media_postable.post(post_message, images))
      end

      def destroy_post_on_social_media
        social_media_postable.remove_post(post_id) if post_id?
      end
  end
end