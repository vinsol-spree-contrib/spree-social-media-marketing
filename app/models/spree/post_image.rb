module Spree
  class PostImage < Image

    MAXIMUM_IMAGE_SIZE = 5

    has_many :social_media_post_images, dependent: :nullify
    has_many :social_media_posts, through: :social_media_post_images

    validates_attachment :attachment, size: { less_than: MAXIMUM_IMAGE_SIZE.megabytes }

    def get_image_binary
      open(get_image_url)
    end

    private
      def get_image_url
        if self.attachment.options[:storage] == :filesystem
          self.attachment.path
        else
          self.attachment.url
        end
      end
  end

end
