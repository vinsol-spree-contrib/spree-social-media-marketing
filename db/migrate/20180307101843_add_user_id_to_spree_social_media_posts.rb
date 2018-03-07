class AddUserIdToSpreeSocialMediaPosts < ActiveRecord::Migration
  def change
    add_reference :spree_social_media_posts, :user, index: true
  end
end
