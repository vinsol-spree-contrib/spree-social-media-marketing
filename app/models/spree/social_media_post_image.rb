module Spree
  class SocialMediaPostImage < ActiveRecord::Base
    belongs_to :social_media_post
    belongs_to :image
  end
end